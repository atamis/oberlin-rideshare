class AddDisabledFieldToListing < ActiveRecord::Migration
  def change
    add_column :listings, :disabled, :boolean, default: false
  end
end
