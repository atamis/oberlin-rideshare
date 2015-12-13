class User < ActiveRecord::Base
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  validates :name, presence: true

  validate :oberlin_email

  has_many :listings
  has_many :messages
  has_many :ride_requests

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  def listing_requests
    listings.inject([]) do |acc, l|
      rs = l.ride_requests
      if not rs.empty?
        acc + rs
      else
        acc
      end
    end
  end

  private
  def oberlin_email
    a = email.split("@")
    if a.length > 1 and a[1] != "oberlin.edu"
      errors.add(:email, "must be oberlin.edu email")
    end
  end
end
