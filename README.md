# Weather Forecast (Rails, Minimal)

A tiny **Ruby on Rails** app that:

- Takes a **city name**
- Uses **Geocoder** to get latitude/longitude
- Calls **Open-Meteo** (free, no API key) via **Faraday**
- Shows **current temp** + **multi-day forecast**
- **Caches by city** for **30 minutes** (shows “Live API” / “Cache”)
---

## Tech stack

- Ruby **3.x**, Rails **7.x** (minimal)
- **SQLite** (default DB)
- **Faraday** (HTTP), **Oj** (JSON parsing)
- **Geocoder** (city → lat/lon)
- Rails **memory_store** cache (dev/test)
- RSpec

---

## Quickstart

```bash
git clone https://github.com/jaybhoyar/weather-forecast-rails
cd weather-forecast-rails

bundle install

# DB (SQLite)
bin/rails db:prepare

# Run server
bin/rails s
# open http://localhost:3000
```


## Usage
  - Home page → enter city (e.g., “Mumbai”).
  - App geocodes city → fetches weather → caches result for 30 minutes.
  - Subsequent requests for the same city show “Cache (≤30m)”.

<img width="648" height="300" alt="Screenshot 2025-08-29 at 10 19 33 AM" src="https://github.com/user-attachments/assets/f10d183f-a64e-4976-854d-28c2a5c964f1" />


<img width="786" height="689" alt="Screenshot 2025-08-29 at 10 19 41 AM" src="https://github.com/user-attachments/assets/eb3a42f5-1dc2-4038-8c3e-2a387b872d39" />




## Endpoints
  - `GET` / → city form
  - `POST` /forecast → redirects to GET /forecast?city=<name>
  - `GET` /forecast → renders forecast for city

## Tests
  ```ruby
    bundle exec rspec
  ```
