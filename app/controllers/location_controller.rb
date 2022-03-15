class LocationController < ApplicationController
  def show
    @location = Location.new(location_params)

    return unless @location.valid?

    latitude, longtitude = LocationLookup.lookup(@location)
    if latitude && longtitude
      WeatherCache.new(latitude:, longtitude:, cache_key: @location.zip).tap do |weather_cache|
        weather_cache.call
        @weather = weather_cache.weather
        @cache_hit = weather_cache.cache_hit?
      end
    end

    # reset the location since we have weather data to give user a blank form
    @location = Location.new
  end

  private

  def location_params
    params.permit(:city, :state, :country, :zip)
  end
end
