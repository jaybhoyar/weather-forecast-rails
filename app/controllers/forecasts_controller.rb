# frozen_string_literal: true

class ForecastsController < ApplicationController
  def new; end

  def create
    redirect_to forecast_path(city: params[:city])
  end


  def show
    city = params[:city].to_s.strip
    return redirect_to root_path, alert: 'Enter a city' if city.blank?

    result = ForecastFetchService.new(city).call

    @city       = city
    @from_cache = result[:from_cache]
    @current    = result[:current]
    @daily      = result[:daily]
  rescue ForecastFetchService::Error => e
    redirect_to root_path, alert: e.message
  end
end
