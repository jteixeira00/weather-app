class WeathersController < ApplicationController
  def index
    latitude = params[:latitude]
    longitude = params[:longitude]
    start_date = params[:start_date]
    end_date = params[:end_date]

    if latitude.blank? || longitude.blank? || start_date.blank? || end_date.blank?
      return render json: { error: 'Missing required parameters' }, status: :bad_request
    end

    weather_service = WeatherService.new
    weather_data = weather_service.get_weather(latitude, longitude, start_date, end_date)

    enriched_data = weather_data.map do |weather|
      weather.as_json.merge(
        description: weather.description
      )
    end

    render json: enriched_data, status: :ok
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def hourly_data
    latitude = params[:latitude]
    longitude = params[:longitude]
    date = params[:date]

    if latitude.blank? || longitude.blank? || date.blank?
      return render json: { error: 'Missing required parameters' }, status: :bad_request
    end

    weather_service = WeatherService.new
    weather = weather_service.get_weather(latitude, longitude, date, date)&.first

    if weather.nil?
      return render json: { error: 'No data available for the given day' }, status: :not_found
    end

    hourly_data = weather.weather_hourlies.order(:hour).map do |hourly|
      {
        hour: hourly.hour,
        temperature: hourly.temperature,
        apparent_temperature: hourly.apparent_temperature,
        humidity: hourly.humidity,
        precipitation: hourly.precipitation,
        precipitation_probability: hourly.precipitation_probability,
        wind_speed: hourly.wind_speed,
        wind_direction: hourly.wind_direction,
        weather_code: hourly.weather_code,
        description: hourly.description
      }
    end

    render json: { date: date, hourly_data: hourly_data }, status: :ok
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end

end