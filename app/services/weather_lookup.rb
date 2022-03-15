class WeatherLookup # WeatherLookup Class
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
    # If latitude or longitude is nil, return an empty Weather object.
    return Weather.new if lat.nil? || lon.nil?

    # Make a request to the OpenWeatherMap Weather API.
    params = {
      appid: Rails.application.credentials.dig(:open_weather, :api_key),
      lat:,
      lon:,
      units: 'metric'
    }

    # Make a request to the OpenWeatherMap Weather API.
    response = Faraday.get(BASE_URL, params, headers)

    # Raise an error if the API request is unsuccessful.
    raise StandardError, "Error Getting Weather Data: #{response.status}" unless response.status == 200

    # Parse the response body and return a Weather object.
    body = JSON.parse(response.body)

    # Return a Weather object with the temperature, low temperature, and high temperature.
    Weather.new(
      temperature: body.dig('main', 'temp'),
      low_temperature: body.dig('main', 'temp_min'),
      high_temperature: body.dig('main', 'temp_max'),
      city: body.dig('name')
    )
  end

  def self.headers
    { 'Content-Type' => 'application/json' }
  end
end
