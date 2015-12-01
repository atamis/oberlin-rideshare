class CreateRideRequests < ActiveRecord::Migration
  def change
    create_table :ride_requests do |t|
      t.integer :listing_id
      t.integer :user_id
      t.integer :state

      t.timestamps null: false
    end
  end
end
