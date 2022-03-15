class LocationController < ApplicationController
  def show
    @location = location
    return unless @location.valid?

    @weather, @cache_hit = fetch_weather(@location)
  end

  private

  def location_params
    params.permit(:city, :state, :country, :zip)
  end

  def location
    Location.new(location_params)
  end

  def fetch_weather(location)
    # Look up the latitude and longitude of the location.
    lat, long = LocationLookup.lookup(location)

    # return if there are not lat/long
    return [nil, false] unless lat && long

    # use the zip as the cache key
    cache_key = location.zip

    cache_hit = Rails.cache.exist?(cache_key)

    # Look up the weather data for the latitude and longitude.
    weather = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      WeatherLookup.lookup(lat, long)
    end

    # reset the location since we have weather data to give user a blank form
    @location = Location.new

    [weather, cache_hit]
  end
end
