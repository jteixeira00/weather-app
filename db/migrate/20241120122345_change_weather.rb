class ChangeWeather < ActiveRecord::Migration[7.1]
  def change
    add_column :weathers, :weather_code, :string, null: true
    add_column :weathers, :sunrise, :datetime, null: true
    add_column :weathers, :sunset, :datetime, null: true
  end
end
