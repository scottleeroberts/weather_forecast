class LocationController < ApplicationController
  def show
    @location = Location.new(location_params)

    # the view will get the invalid location to allow the user to correct it
    return unless @location.valid?

    # this is the cache key for the location
    cache_key = @location.zip

    # check if the location is in the cache
    @cache_hit = Rails.cache.exist?(cache_key)

    # if the location is not in the cache, fetch it from the API
    @weather = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      lat, long = LocationLookup.lookup(@location)
      WeatherLookup.lookup(lat, long)
    end
  end

  private

  def location_params
    # permit the location parameters
    params.permit(:city, :state, :country, :zip)
  end

  def location
    # create a new location object
    Location.new(location_params)
  end
end
