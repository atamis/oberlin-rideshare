class GeneralLocation < ActiveRecord::Base
  validates :name, presence: true
  has_many :departures, class_name: "Listing",
    foreign_key: :depart_loc_id
  has_many :destinations, class_name: "Listing",
    foreign_key: :dest_loc_id
end
