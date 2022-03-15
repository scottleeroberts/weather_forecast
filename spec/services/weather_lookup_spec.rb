require 'rails_helper'

RSpec.describe WeatherLookup do
  describe '.lookup' do
    let(:lat) { 40.7128 }
    let(:lon) { -74.0060 }
    let(:response_body) { '{"main":{"temp":25,"temp_min":20,"temp_max":30}}' }
    let(:response) { instance_double('Faraday::Response', status: 200, body: response_body) }

    before do
      allow(Faraday).to receive(:get).and_return(response)
    end

    it 'returns a Weather object with the correct attributes' do
      weather = described_class.lookup(lat, lon)
      expect(weather).to be_a(Weather)
      expect(weather.temperature).to eq(25)
      expect(weather.low_temperature).to eq(20)
      expect(weather.high_temperature).to eq(30)
    end

    context 'when the latitude or longitude is nil' do
      it 'returns a new Weather object' do
        weather = described_class.lookup(nil, nil)
        expect(weather).to be_a(Weather)
      end
    end

    context 'when the API request fails' do
      let(:response) { instance_double('Faraday::Response', status: 500, body: '{}') }

      it 'raises a StandardError' do
        expect { described_class.lookup(lat, lon) }.to raise_error(StandardError, /Error Getting Weather Data/)
      end
    end
  end
end
