require 'rails_helper'

RSpec.describe Weather do
  subject { described_class.new(temperature: 25, low_temperature: 20, high_temperature: 30) }

  it 'is valid with all attributes present' do
    expect(subject).to be_valid
  end

  it 'is invalid without a temperature' do
    subject.temperature = nil
    expect(subject).not_to be_valid
  end

  it 'is invalid without a low temperature' do
    subject.low_temperature = nil
    expect(subject).not_to be_valid
  end

  it 'is invalid without a high temperature' do
    subject.high_temperature = nil
    expect(subject).not_to be_valid
  end
end
