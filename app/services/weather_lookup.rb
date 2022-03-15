class WeatherLookup
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
