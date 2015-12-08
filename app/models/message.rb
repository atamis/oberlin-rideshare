class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :ride_request
end
