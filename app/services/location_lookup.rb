# LocationLookup Class
#
# Provides a method to lookup the latitude and longitude of a given location
# using the OpenWeatherMap Geocoding API.
# URL of the OpenWeatherMap Geocoding API endpoint
# Looks up the latitude and longitude of a given location.
#
# @param location [Object] an object that responds to `city`, `state`, and `country` methods.
# @return [Array] an array containing the latitude and longitude of the location.
# @raise [StandardError] if the API request is unsuccessful or if the response format is invalid.
class LocationLookup
  URL = 'http://api.openweathermap.org/geo/1.0/direct'.freeze

  def self.lookup(location)
    # build a request to the OpenWeatherMap Geocoding API.
    params = {
      q: "#{location.city},#{location.state},#{location.country}",
      appid: Rails.application.credentials.dig(:open_weather, :api_key)
    }

    # Make a request to the OpenWeatherMap Geocoding API.
    response = Faraday.get(URL, params, headers)

    # Raise an error if the API request is unsuccessful.
    raise StandardError, "Error Getting Lat/Long: #{response.status}" unless response.status == 200

    # Parse the response body and return the latitude and longitude.
    body = JSON.parse(response.body)
    lat = body.dig(0, 'lat')
    lon = body.dig(0, 'lon')

    [lat, lon]
  end

  def self.headers
    { 'Content-Type' => 'application/json' }
  end
end
