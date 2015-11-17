class CreateGeneralLocations < ActiveRecord::Migration
  def change
    create_table :general_locations do |t|
      t.string :name, unique: true, null: false

      t.timestamps null: false
    end
  end
end
