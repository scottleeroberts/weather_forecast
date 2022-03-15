class WeatherCache
  def initialize(latitude:, longtitude:, cache_key:)
    @latitude = latitude
    @longtitude = longtitude
    @cache_key = cache_key
  end

  def call
    @is_cache_hit ||= Rails.cache.exist?(cache_key)
    @is_called = true
  end

  def cache_hit?
    raise 'You must call the `call` method before calling `cache_hit?`' unless @is_called

    @is_cache_hit
  end

  def weather
    raise 'You must call the `call` method before calling `weather`' unless @is_called

    # Look up the weather data for the latitude and longitude.
    Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      WeatherLookup.lookup(latitude, longtitude)
    end
  end

  private

  attr_reader :latitude, :longtitude, :cache_key
end
