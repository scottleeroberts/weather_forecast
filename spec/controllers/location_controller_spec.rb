require 'rails_helper'

RSpec.describe LocationController, type: :controller do
  describe 'GET #show' do
    context 'with valid location parameters' do
      let(:valid_params) { { city: 'New York', state: 'NY', country: 'USA', zip: '10001' } }
      let(:location) { instance_double(Location, valid?: true, zip: '10001') }
      let(:weather) { double('WeatherData') }

      before do
        # Allow Location.new to be called with no arguments
        allow(Location).to receive(:new).with(no_args).and_return(Location.new)

        # Ensure that the parameters are converted to a hash
        allow(controller).to receive(:location_params).and_return(valid_params.stringify_keys)
        allow(Location).to receive(:new).with(valid_params.stringify_keys).and_return(location)
        allow(LocationLookup).to receive(:lookup).with(location).and_return([40.7128, -74.0060])
        allow(WeatherLookup).to receive(:lookup).and_return(weather)
        allow(Rails.cache).to receive(:exist?).and_return(false)
        allow(Rails.cache).to receive(:fetch).and_return(weather)
      end

      it 'assigns @location' do
        get :show, params: valid_params
        expect(assigns(:location)).to be_a(Location)
        expect(assigns(:location)).not_to be_valid # reset to blank
      end

      it 'assigns @weather' do
        get :show, params: valid_params
        expect(assigns(:weather)).to eq(weather)
      end

      it 'assigns @cache_hit' do
        get :show, params: valid_params
        expect(assigns(:cache_hit)).to eq(false)
      end
    end

    context 'with invalid location parameters' do
      let(:invalid_params) { { city: 'Invalid City' } }
      let(:location) { instance_double(Location, valid?: false) }

      before do
        # Allow Location.new to be called with no arguments
        allow(Location).to receive(:new).with(no_args).and_return(Location.new)

        # Ensure that the parameters are converted to a hash
        allow(controller).to receive(:location_params).and_return(invalid_params.stringify_keys)
        allow(Location).to receive(:new).with(invalid_params.stringify_keys).and_return(location)
      end

      it 'does not assign @weather' do
        get :show, params: invalid_params
        expect(assigns(:weather)).to be_nil
      end

      it 'does not assign @cache_hit' do
        get :show, params: invalid_params
        expect(assigns(:cache_hit)).to be_nil
      end
    end
  end
end
