# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_11_20_151959) do
  create_table "locations", force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.string "timezone"
    t.float "elevation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["latitude", "longitude"], name: "index_locations_on_latitude_and_longitude", unique: true
  end

  create_table "weather_hourlies", force: :cascade do |t|
    t.integer "weather_id", null: false
    t.integer "hour", null: false
    t.float "temperature", null: false
    t.float "apparent_temperature"
    t.float "precipitation", null: false
    t.float "precipitation_probability"
    t.float "humidity"
    t.float "wind_speed"
    t.float "wind_direction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "weather_code"
    t.index ["weather_id", "hour"], name: "index_weather_hourlies_on_weather_id_and_hour", unique: true
    t.index ["weather_id"], name: "index_weather_hourlies_on_weather_id"
  end

  create_table "weathers", force: :cascade do |t|
    t.integer "location_id", null: false
    t.date "date", null: false
    t.float "temperature_min"
    t.float "precipitation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "weather_code"
    t.datetime "sunrise"
    t.datetime "sunset"
    t.float "sunshine_duration"
    t.float "temperature_max"
    t.index ["location_id", "date"], name: "index_weathers_on_location_id_and_date", unique: true
    t.index ["location_id"], name: "index_weathers_on_location_id"
  end

  add_foreign_key "weather_hourlies", "weathers"
  add_foreign_key "weathers", "locations"
end
