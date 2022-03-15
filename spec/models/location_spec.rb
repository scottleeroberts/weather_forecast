require 'rails_helper'

RSpec.describe Location do
  subject { described_class.new(city: 'New York', state: 'NY', country: 'USA', zip: '10001') }

  it 'is valid with all attributes present' do
    expect(subject).to be_valid
  end

  it 'is invalid without a city' do
    subject.city = nil
    expect(subject).not_to be_valid
  end

  it 'is invalid without a state' do
    subject.state = nil
    expect(subject).not_to be_valid
  end

  it 'is invalid without a country' do
    subject.country = nil
    expect(subject).not_to be_valid
  end

  it 'is invalid without a zip code' do
    subject.zip = nil
    expect(subject).not_to be_valid
  end
end
