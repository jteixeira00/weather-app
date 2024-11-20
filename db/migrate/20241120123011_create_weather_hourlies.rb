class CreateWeatherHourlies < ActiveRecord::Migration[7.1]
  def change
    create_table :weather_hourlies do |t|
      t.references :weather, null: false, foreign_key: true
      t.integer :hour, null: false                      # Hour of the record (0–23)
      t.float :temperature, null: false
      t.float :apparent_temperature
      t.float :precipitation, null: false
      t.float :precipitation_probability
      t.float :humidity
      t.float :wind_speed
      t.float :wind_direction

      t.timestamps
    end

    add_index :weather_hourlies, [:weather_id, :hour], unique: true
  end
end
