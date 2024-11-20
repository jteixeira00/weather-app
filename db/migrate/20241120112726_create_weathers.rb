class CreateWeathers < ActiveRecord::Migration[7.1]
  def change
    create_table :weathers do |t|
      t.references :location, null: false, foreign_key: true
      t.date :date, null: false
      t.float :temperature
      t.float :precipitation

      t.timestamps
    end

    add_index :weathers, [:location_id, :date], unique: true
  end
end
