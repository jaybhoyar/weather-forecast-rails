# Weather Forecast (Rails, Minimal)

A tiny **Ruby on Rails** app that:

- Takes a **city name**
- Uses **Geocoder** to get latitude/longitude
- Calls **Open-Meteo** (free, no API key) via **Faraday**
- Shows **current temp** + **multi-day forecast**
- **Caches by city** for **30 minutes** (shows “Live API” / “Cache”)

---

## Features

- Input: **city** (e.g., _“Mumbai”_)
- Geocode → **lat/lon**
- Weather via **Open-Meteo** (no key required)
- **30-minute cache** per canonicalized city (case/space-insensitive)
- Cache indicator (Live vs Cache)
- Minimal UI (SCSS)
- **RSpec** tests (service + request)

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
git clone <your-repo-url>
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


## Endpoints
  - `GET` / → city form
  - `POST` /forecast → redirects to GET /forecast?city=<name>
  - `GET` /forecast → renders forecast for city

## Tests
  ```ruby
    bundle exec rspec
  ```