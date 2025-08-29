# spec/services/weather_client_spec.rb
require "rails_helper"

RSpec.describe WeatherClient do
  subject(:client) { described_class.new }

  let(:lat) { 37.323 }
  let(:lon) { -122.032 }

  let(:body_hash) do
    {
      "current_weather" => {
        "temperature" => 21.7,
        "weathercode" => 1
      },
      "daily" => {
        "time" => ["2025-08-29", "2025-08-30"],
        "temperature_2m_max" => [25.0, 26.5],
        "temperature_2m_min" => [15.0, 14.2],
        "weathercode" => [1, 2]
      }
    }
  end
  let(:body_json) { Oj.dump(body_hash) }

  describe "#fetch" do
    it "returns normalized current and daily forecast" do
      response = instance_double(Faraday::Response,
        success?: true, status: 200, body: body_json)

      allow(Faraday).to receive(:get).and_return(response)

      data = client.fetch(lat: lat, lon: lon)

      expect(data).to include(:current, :daily)
      expect(data[:current]).to include(:temp, :description)
      expect(data[:current][:temp]).to eq(21.7)
      expect(data[:current][:description]).to include("Code 1")

      expect(data[:daily]).to be_an(Array).and have_attributes(length: 2)
      expect(data[:daily].first).to include(
        date: "2025-08-29",
        high: 25.0,
        low: 15.0,
        description: "Code 1"
      )
    end

    it "passes the expected query params to Faraday" do
      response = instance_double(Faraday::Response,
        success?: true, status: 200, body: body_json)

      expect(Faraday).to receive(:get).with(
        WeatherClient::BASE_URL,
        hash_including(
          latitude: lat,
          longitude: lon,
          current_weather: true,
          timezone: "auto",
          daily: "temperature_2m_max,temperature_2m_min,weathercode"
        )
      ).and_return(response)

      client.fetch(lat: lat, lon: lon)
    end

    it "raises when API responds non-success" do
      response = instance_double(Faraday::Response,
        success?: false, status: 500, body: "oops")

      allow(Faraday).to receive(:get).and_return(response)

      expect { client.fetch(lat: lat, lon: lon) }
        .to raise_error(RuntimeError, /Weather API failed \(500\)/)
    end

    it "propagates Faraday timeouts" do
      allow(Faraday).to receive(:get).and_raise(Faraday::TimeoutError.new("timeout"))

      expect { client.fetch(lat: lat, lon: lon) }
        .to raise_error(Faraday::TimeoutError)
    end
  end
end
