class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.float :latitude
      t.float :longitude
      t.string :timezone
      t.float :elevation

      t.timestamps
    end

    add_index :locations, [:latitude, :longitude], unique: true
  end
end
