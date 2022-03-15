require 'rails_helper'

RSpec.describe LocationController, type: :controller do
  describe 'GET #show' do
    context 'when location params are present' do
      let(:location_params) { { city: 'New York', state: 'NY', country: 'USA' } }
      let(:permitted_params) { ActionController::Parameters.new(location_params).permit(:city, :state, :country) }
      let(:mock_location) { Location.new(location_params) }
      let(:mock_weather) { Weather.new('temperature' => 25, 'low_temperature' => 20, 'high_temperature' => 30, 'cached_at' => Time.now) }

      before do
        allow(Location).to receive(:new).with(permitted_params).and_return(mock_location)
        allow(LocationLookup).to receive(:lookup).with(mock_location).and_return([40.7128, -74.0060])
        allow(WeatherLookup).to receive(:lookup).with(anything, anything).and_return(mock_weather)
        get :show, params: location_params
      end

      it 'assigns @location' do
        expect(assigns(:location)).to eq(mock_location)
      end

      it 'assigns @weather' do
        expect(assigns(:weather)).to eq(mock_weather)
      end
    end

    context 'when location params are not present' do
      before do
        get :show
      end

      it 'does not assign @weather' do
        expect(assigns(:weather)).to be_nil
      end
    end
  end
end
