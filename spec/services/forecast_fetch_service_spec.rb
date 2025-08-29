require 'rails_helper'

RSpec.describe ForecastFetchService do
  it 'geocodes city, fetches, and caches by city' do
    geo = double(latitude: 37.323, longitude: -122.032)
    allow(Geocoder).to receive(:search).with('Cupertino').and_return([geo])

    client = instance_double(WeatherClient)
    data = { current: { temp: 22.5, description: 'Code 1' }, daily: [] }
    allow(WeatherClient).to receive(:new).and_return(client)
    allow(client).to receive(:fetch).with(lat: 37.323, lon: -122.032).and_return(data)

    first  = described_class.new('Cupertino').call
    second = described_class.new('Cupertino').call

    expect(first[:from_cache]).to eq(false)
    expect(second[:from_cache]).to eq(true)
    expect(first[:current][:temp]).to eq(22.5)
  end
end
