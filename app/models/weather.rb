# Description: This file contains the Weather class which is used to store the temperature, low temperature, and high temperature of a location.
# It is non-db backed model
class Weather
  include ActiveModel::Model

  # Attributes for the temperature, low temperature, and high temperature.
  attr_accessor :temperature, :low_temperature, :high_temperature, :city

  # Validates the presence of the temperature, low temperature, and high temperature.
  validates :temperature, :low_temperature, :high_temperature, :city, presence: true
end
