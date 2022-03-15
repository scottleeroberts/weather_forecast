class LocationController < ApplicationController
  def show
    if location_params.present?
      @location = Location.new(location_params)
      @cache_key = "#{@location.city}/#{@location.state}/#{@location.country}/#{@location.zip}"
      @weather = Rails.cache.fetch(@cache_key, expires_in: 30.minutes) do
        lat, long = LocationLookup.lookup(@location)
        WeatherLookup.lookup(lat, long)
      end
    else
      @location = Location.new
    end
  end

  private

  def location_params
    params.permit(:city, :state, :country, :zip)
  end
end
