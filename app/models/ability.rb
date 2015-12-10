class Ability
  include CanCan::Ability

  def initialize(user)

    # Things that listing owners can do to RideRequests
    alias_action :accept, :post, to: :participate

    if user
      can :manage, Listing, user_id: user.id

      can :manage, RideRequest, user_id: user.id
      can :post, RideRequest, user_id: user.id

      can :participate, RideRequest do |rr|
        rr.listing.user_id = user.id
      end

      can :manage, Message, user_id: user.id

      if user.admin?
        can :manage, :all
      end
    end
  end
end
