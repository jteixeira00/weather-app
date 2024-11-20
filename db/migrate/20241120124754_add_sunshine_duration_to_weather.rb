class AddSunshineDurationToWeather < ActiveRecord::Migration[7.1]
  def change
    add_column :weathers, :sunshine_duration, :float

    rename_column :weathers, :temperature, :temperature_min
    add_column :weathers, :temperature_max, :float
  end
end
