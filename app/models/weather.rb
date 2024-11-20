# == Schema Information
#
# Table name: weathers
#
#  id                :integer          not null, primary key
#  date              :date             not null
#  precipitation     :float
#  sunrise           :datetime
#  sunset            :datetime
#  sunshine_duration :float
#  temperature_max   :float
#  temperature_min   :float
#  weather_code      :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  location_id       :integer          not null
#
# Indexes
#
#  index_weathers_on_location_id           (location_id)
#  index_weathers_on_location_id_and_date  (location_id,date) UNIQUE
#
# Foreign Keys
#
#  location_id  (location_id => locations.id)

class Weather < ApplicationRecord
  include WeatherCodeMappings

  belongs_to :location

  validates :date, presence: true
  validates :precipitation, presence: true

  has_many :weather_hourlies, dependent: :destroy

  def description
    WeatherCodeMappings::Descriptions[weather_code.to_i] || "Unknown weather code"
  end

end
