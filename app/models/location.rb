# Description: This file contains the Weather class which is used to store the location information
# It is non-db backed model
class Location
  include ActiveModel::Model

  # Attributes for the city, state, country, and zip.
  attr_accessor :city, :state, :country, :zip

  # Validates the presence of the city, state, country, and zip.
  validates :city, :state, :country, :zip, presence: true

  # validate the zip is exactly 5 digits
  validates :zip, length: { is: 5 }
end
