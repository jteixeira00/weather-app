class AddWeatherCodeWeatherHourly < ActiveRecord::Migration[7.1]
  def change
    add_column :weather_hourlies, :weather_code, :string, null: true
  end
end
