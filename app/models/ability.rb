class Ability
  include CanCan::Ability

  def initialize(user, namespace)
    return unless user

    if user.administrator? && namespace == :administrator
      can :manage,  Permission
      can :read,    Sync
      can :read,    :sidekiq
    end

    if user.curator? && namespace == :curator
      can :manage, Group
    end

    if user.dean? && namespace == :dean
      can :read,   Statistic
      can :manage, Permission, :context_type => ['Group']
      can :manage, Miss,       :missing_type => ['Student']
      can :read,   Disruption
    end

    if user.education_department? && namespace == :education_department
      can :read,   Statistic
      can :manage, Permission, :context_type => ['Faculty', 'Subdepartment']
      can :read,   Disruption
      can :manage, Miss,       :missing_type => ['Lecturer']
    end

    if user.group_leader? && namespace == :group_leader
      can :manage, Lesson
      can :read,   Group
      can :read,   Unfilled
    end
  end
end
