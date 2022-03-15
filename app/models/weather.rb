class Weather
  include ActiveModel::Model

  attr_accessor :temperature, :low_temperature, :high_temperature

  validates :temperature, :low_temperature, :high_temperature, presence: true
end
