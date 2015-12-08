class RideRequest < ActiveRecord::Base
  enum state: [:undecided, :rejected, :accepted]
  belongs_to :user
  belongs_to :listing
  has_many :messages
end
