require "rails_helper"

RSpec.describe "Forecasts", type: :request do
  describe "POST /forecast" do

    it "renders forecast for Mumbai" do
      # Stub Geocoder to resolve Mumbai → lat/lon
      geo = double(latitude: 19.0760, longitude: 72.8777)
      allow(Geocoder).to receive(:search).with("Mumbai").and_return([geo])

      # Stub WeatherClient to return fake forecast
      fake_data = {
        current: { temp: 30.5, description: "Code 1" },
        daily: [
          { date: "2025-08-29", high: 32.0, low: 27.0, description: "Code 1" }
        ]
      }
      allow(WeatherClient).to receive(:new).and_return(
        instance_double(WeatherClient, fetch: fake_data)
      )

      # Perform request
      post "/forecast", params: { city: "Mumbai" }
      follow_redirect!

      # Assertions
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Forecast")
      expect(response.body).to include("Mumbai")
      expect(response.body).to include("Current")
      expect(response.body).to include("30.5")  # temp
    end
  end
end
