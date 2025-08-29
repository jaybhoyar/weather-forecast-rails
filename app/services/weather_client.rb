# frozen_string_literal: true

# WeatherClient
class WeatherClient
  BASE_URL = 'https://api.open-meteo.com/v1/forecast'

  def fetch(lat:, lon:)
    res = Faraday.get(
      BASE_URL,
      {
        latitude: lat,
        longitude: lon,
        daily: 'temperature_2m_max,temperature_2m_min,weathercode',
        current_weather: true,
        timezone: 'auto'
      }
    )
    raise "Weather API failed (#{res.status})" unless res.success?
    parse(res.body)
  end

  private

  def parse(body)
    json   = Oj.load(body)
    curr   = json['current_weather']
    daily  = json['daily']

    {
      current: {
        temp: curr['temperature'],
        description: "Code #{curr['weathercode']}"
      },
      daily: daily['time'].zip(
        daily['temperature_2m_max'],
        daily['temperature_2m_min'],
        daily['weathercode']
      ).map { |date, hi, lo, code|
        { date:, high: hi, low: lo, description: "Code #{code}" }
      }
    }
  end
end
