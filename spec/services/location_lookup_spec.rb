require 'rails_helper'

RSpec.describe LocationLookup do
  describe '.lookup' do
    let(:location) { instance_double('Location', city: 'New York', state: 'NY', country: 'USA') }
    let(:response_body) { '[{"lat":40.7128,"lon":-74.0060}]' }
    let(:response) { instance_double('Faraday::Response', status: 200, body: response_body) }

    before do
      allow(Faraday).to receive(:get).and_return(response)
    end

    it 'returns the latitude and longitude for the given location' do
      lat, lon = described_class.lookup(location)
      expect(lat).to eq(40.7128)
      expect(lon).to eq(-74.0060)
    end

    context 'when the API request fails' do
      let(:response) { instance_double('Faraday::Response', status: 500, body: '{}') }

      it 'raises a StandardError' do
        expect { described_class.lookup(location) }.to raise_error(StandardError, /Error Getting Lat\/Long/)
      end
    end
  end
end
