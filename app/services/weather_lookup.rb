class WeatherLookup
  def self.lookup(lat, lon)
    return Weather.new if lat.nil? || lon.nil?

    url = 'http://api.openweathermap.org/data/2.5/weather'.freeze
    headers = { 'Content-Type' => 'application/json' }
    params = {
      appid: '9f4af7832c15d9048ae1a43dcae3b5a8',
      lat:,
      lon:,
      units: 'metric'
    }
    response = Faraday.get(url, params, headers)

    raise StandardError, "Error Getting Weather Data: #{response.status}" unless response.status == 200

    body = JSON.parse(response.body)
    temp = body['main']['temp']
    low_temp = body['main']['temp_min']
    high_temp = body['main']['temp_max']
    puts temp

    Weather.new(
      'temperature' => temp,
      'low_temperature' => low_temp,
      'high_temperature' => high_temp,
      'cached_at' => Time.now
    )
  end
end
