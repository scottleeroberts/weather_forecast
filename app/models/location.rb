include ActiveModel::Model

attr_accessor :city, :state, :country, :zip

validates :city, :state, :country, :zip, presence: true
