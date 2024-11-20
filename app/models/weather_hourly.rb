# == Schema Information
#
# Table name: weather_hourlies
#
#  id                        :integer          not null, primary key
#  apparent_temperature      :float
#  hour                      :integer          not null
#  humidity                  :float
#  precipitation             :float            not null
#  precipitation_probability :float
#  temperature               :float            not null
#  weather_code              :string
#  wind_direction            :float
#  wind_speed                :float
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  weather_id                :integer          not null
#
# Indexes
#
#  index_weather_hourlies_on_weather_id           (weather_id)
#  index_weather_hourlies_on_weather_id_and_hour  (weather_id,hour) UNIQUE
#
# Foreign Keys
#
#  weather_id  (weather_id => weathers.id)
#
class WeatherHourly < ApplicationRecord
  belongs_to :weather

  # Convenience method to return the full timestamp
  def timestamp
    weather.date.to_time.change(hour: hour)
  end

  def description
    WeatherCodeMappings::Descriptions[weather_code.to_i] || "Unknown weather code"
  end
end
