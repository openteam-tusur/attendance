class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    if user.administrator?
      can :manage,  Permission
      can :read,    Sync
      can :read,    :sidekiq
    end
  end
end
