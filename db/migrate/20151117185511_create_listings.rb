class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.integer :user_id
      t.string :depart_maps_id
      t.integer :depart_loc_id
      t.datetime :depart_range_start
      t.datetime :depart_range_end
      t.string :dest_maps_id
      t.integer :dest_loc_id
      t.datetime :dest_range_start
      t.datetime :dest_range_end
      t.integer :type
      t.decimal :money
      t.text :comments
      t.integer :detour_time

      t.timestamps null: false
    end
    add_foreign_key :listings, :general_locations, column: :depart_loc_id
    add_foreign_key :listings, :general_locations, column: :dest_loc_id
  end
end

