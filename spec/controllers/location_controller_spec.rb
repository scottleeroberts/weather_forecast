require 'rails_helper'

RSpec.describe LocationController, type: :controller do
  describe 'GET #show' do
    let(:valid_params) { { city: 'New York', state: 'NY', country: 'USA', zip: '10001' } }
    let(:invalid_params) { { city: '', state: '', country: '', zip: '' } }
    let(:cache_key) { valid_params[:zip] }
    let(:mock_weather) { instance_double('Weather', temperature: 25) }

    context 'when location params are valid' do
      before do
        allow(LocationLookup).to receive(:lookup).and_return([40.7128, -74.0060])
        allow(WeatherLookup).to receive(:lookup).and_return(mock_weather)
        allow(Rails.cache).to receive(:exist?).with(cache_key).and_return(false)
        allow(Rails.cache).to receive(:fetch).with(cache_key, expires_in: 30.minutes).and_return(mock_weather)
      end

      it 'sets @location' do
        get :show, params: valid_params
        expect(assigns(:location)).to have_attributes(valid_params)
      end

      it 'checks the cache for existing weather data' do
        get :show, params: valid_params
        expect(assigns(:cache_hit)).to be false
      end

      it 'fetches weather data and caches it' do
        get :show, params: valid_params
        expect(assigns(:weather)).to eq(mock_weather)
      end
    end

    context 'when location params are invalid' do
      it 'does not set @weather' do
        get :show, params: invalid_params
        expect(assigns(:weather)).to be_nil
      end
    end
  end
end
