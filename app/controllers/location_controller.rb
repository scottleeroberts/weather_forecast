class LocationController < ApplicationController
  before_action :initialize_location

  def show
    return unless @location.valid?

    @weather, @cache_hit = fetch_weather
    #
    # reset the location since we have weather data to give user a blank form
    @location = Location.new
  end

  private

  def initialize_location
    @location = Location.new(location_params)
  end

  def location_params
    params.permit(:city, :state, :country, :zip)
  end

  def fetch_weather
    # Look up the latitude and longitude of the location.
    lat, long = LocationLookup.lookup(@location)

    # return if there are not lat/long
    return [nil, false] unless lat && long

    # Look up the weather data for the latitude and longitude.
    cache_key = @location.zip
    cache_hit = Rails.cache.exist?(cache_key)
    weather = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      WeatherLookup.lookup(lat, long)
    end

    [weather, cache_hit]
  rescue StandardError => e
    Rails.logger.error("Error fetching weather: #{e.message}")
    [nil, false]
  end
end
