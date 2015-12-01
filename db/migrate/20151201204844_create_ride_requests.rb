class CreateRideRequests < ActiveRecord::Migration
  def change
    create_table :ride_requests do |t|
      t.integer :listing_id
      t.integer :user_id
      t.integer :state, default: 0

      t.timestamps null: false
    end

    add_foreign_key :ride_requests, :listings, column: :listing_id
    add_foreign_key :ride_requests, :user, column: :user_id
  end
end
