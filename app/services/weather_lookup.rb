class WeatherLooku # WeatherLookup Class
  #
  # Provides a method to lookup weather data for a given latitude and longitude
  # using the OpenWeatherMap Weather API.
  # Base URL of the OpenWeatherMap Weather API endpoint

  # Looks up weather data for a given latitude and longitude.
  #
  # @param lat [Float] the latitude of the location.
  # @param lon [Float] the longitude of the location.
  # @return [Weather] a Weather object containing the temperature, low temperature,
  #   and high temperature for the location.
  # @raise [StandardError] if the API request is unsuccessful or if the response format is invalid.
  BASE_URL = 'http://api.openweathermap.org/data/2.5/weather'.freeze

  def self.lookup(lat, lon)
    return Weather.new if lat.nil? || lon.nil?

    params = {
      appid: '9f4af7832c15d9048ae1a43dcae3b5a8',
      lat:,
      lon:,
      units: 'metric'
    }
    response = Faraday.get(BASE_URL, params, headers)

    raise StandardError, "Error Getting Weather Data: #{response.status}" unless response.status == 200

    body = JSON.parse(response.body)

    Weather.new(
      temperature: body.dig('main', 'temp'),
      low_temperature: body.dig('main', 'temp_min'),
      high_temperature: body.dig('main', 'temp_max')
    )
  end

  def self.headers
    { 'Content-Type' => 'application/json' }
  end
end
