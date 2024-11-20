require 'net/http'
require 'json'

class WeatherService
  def get_weather(latitude, longitude, start_date, end_date)
    location = Location.find_or_create_by!(latitude: latitude, longitude: longitude)


    existing_weather = Weather.where(location: location, date: start_date..end_date).pluck(:date).to_set

    requested_dates = (Date.parse(start_date)..Date.parse(end_date)).to_a
    missing_dates = requested_dates
    missing_dates = missing_dates - existing_weather.to_a if existing_weather.present?

    if missing_dates.empty?
      return Weather.where(location: location, date: start_date..end_date).order(:date)
    end

    earliest_missing_date = missing_dates.min
    latest_missing_date = missing_dates.max

    fetch_and_store_weather(location, earliest_missing_date, latest_missing_date)

    Weather.where(location: location, date: start_date..end_date).order(:date)
  end

  private

  def fetch_and_store_weather(location, start_date, end_date)
    data = fetch_weather_from_api(location, start_date, end_date)

    data[:daily].each do |entry|
      weather = Weather.create!(
        location: location,
        date: entry[:date],
        weather_code: entry[:weather_code],
        temperature_max: entry[:temperature_max],
        temperature_min: entry[:temperature_min],
        sunrise: entry[:sunrise],
        sunset: entry[:sunset],
        sunshine_duration: entry[:sunshine_duration],
        precipitation: entry[:precipitation]
      )

      entry[:hourly].each do |hourly_entry|
        WeatherHourly.create!(
          weather: weather,
          hour: hourly_entry[:hour],
          temperature: hourly_entry[:temperature],
          apparent_temperature: hourly_entry[:apparent_temperature],
          humidity: hourly_entry[:humidity],
          precipitation: hourly_entry[:precipitation],
          precipitation_probability: hourly_entry[:precipitation_probability],
          wind_speed: hourly_entry[:wind_speed],
          wind_direction: hourly_entry[:wind_direction],
          weather_code: hourly_entry[:weather_code]
        )
      end
    end
  end

  def fetch_weather_from_api(location, start_date, end_date)
    url = URI("https://api.open-meteo.com/v1/forecast?latitude=#{location.latitude}&longitude=#{location.longitude}&start_date=#{start_date}&end_date=#{end_date}&hourly=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation_probability,precipitation,wind_speed_10m,wind_direction_10m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,sunshine_duration,precipitation_sum&timezone=#{location.timezone || "GMT"}")

    response = Net::HTTP.get(url)
    raw_data = JSON.parse(response)

    daily_data = parse_daily_data(raw_data)

    hourly_data = parse_hourly_data(raw_data)

    daily_data.each do |day|
      day[:hourly] = hourly_data.select { |hour| hour[:date] == day[:date] }
    end

    { daily: daily_data }
  end

  def parse_daily_data(data)
    daily = data['daily']
    times = daily['time']

    times.each_with_index.map do |date, index|
      {
        date: date,
        weather_code: daily['weather_code'][index],
        temperature_max: daily['temperature_2m_max'][index],
        temperature_min: daily['temperature_2m_min'][index],
        sunrise: daily['sunrise'][index],
        sunset: daily['sunset'][index],
        sunshine_duration: daily['sunshine_duration'][index],
        precipitation: daily['precipitation_sum'][index]
      }
    end
  end

  def parse_hourly_data(data)
    hourly = data['hourly']
    times = hourly['time']

    times.each_with_index.map do |timestamp, index|
      {
        date: timestamp.split('T').first,
        hour: timestamp.split('T').last.to_i,
        temperature: hourly['temperature_2m'][index],
        apparent_temperature: hourly['apparent_temperature'][index],
        humidity: hourly['relative_humidity_2m'][index],
        precipitation: hourly['precipitation'][index],
        precipitation_probability: hourly['precipitation_probability'][index],
        wind_speed: hourly['wind_speed_10m'][index],
        wind_direction: hourly['wind_direction_10m'][index],
        weather_code: hourly['weather_code'][index]
      }
    end
  end
end