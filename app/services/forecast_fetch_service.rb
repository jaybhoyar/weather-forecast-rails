# frozen_string_literal: true

# ForecastFetchService
class ForecastFetchService
  class Error < StandardError; end

  CACHE_TTL = 30.minutes

  def self.call(address:)
    new(address).call
  end

  def initialize(city)
    @city = city.to_s.strip
  end

  def call
    lat, lon = geocode_city!(@city)
    cache_key = "forecast:city:#{canonical_city(@city)}"

    # return from cache if present
    if (cached = Rails.cache.read(cache_key))
      return cached.merge(from_cache: true)
    end

    # else fetch from API
    data = WeatherClient.new.fetch(lat:, lon:)
    Rails.cache.write(cache_key, data, expires_in: CACHE_TTL)
    data.merge(from_cache: false)
  rescue => e
    raise Error, e.message
  end

  private

  def geocode_city!(name)
    result = Geocoder.search(name).first
      raise Error, 'City not found' unless result&.latitude && result&.longitude

      [result.latitude, result.longitude]
  end

  def canonical_city(name)
    name.downcase.gsub(/\s/, ' ').strip
  end
end
