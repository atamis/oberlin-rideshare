class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.integer :ride_request_id
      t.text :body

      t.timestamps null: false
    end

    add_foreign_key :messages, :users, column: :user_id
    add_foreign_key :messages, :ride_requests, column: :ride_request_id
  end
end
