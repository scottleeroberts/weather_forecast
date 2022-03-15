class Location
  include ActiveModel::Model

  attr_accessor :city, :state, :country, :zip

  validates :city, :state, :country, :zip, presence: true

  # validate the zip is exactly 5 digits
  validates :zip, length: { is: 5 }
end
