class Weather
  include ActiveModel::Model

  attr_accessor :temperature, :low_temperature, :high_temperature, :cached_at

  validates :temperature, :low_temperature, :high_temperature, :cached_at, presence: true
end
