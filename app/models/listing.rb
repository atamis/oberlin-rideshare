class Listing < ActiveRecord::Base
  enum listing_type: [:request, :offer]
  belongs_to :depart_location, class_name: "GeneralLocation",
    foreign_key: :depart_loc_id
  belongs_to :dest_location, class_name: "GeneralLocation",
    foreign_key: :dest_loc_id
end
