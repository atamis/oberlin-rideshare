class GeneralLocation < ActiveRecord::Base
  validates :name, presence: true
end
