class Ability
  include CanCan::Ability

  def initialize(user)

    if user
      can :manage, Listing, user_id: user.id

      can [:show, :create, :update, :destroy], RideRequest, user_id: user.id
      can :post, RideRequest, user_id: user.id

      can [:accept, :post, :show], RideRequest do |rr|
        rr.listing.user_id == user.id
      end

      can :manage, Message, user_id: user.id

      if user.admin?
        can :manage, :all
      end
    end
  end
end
