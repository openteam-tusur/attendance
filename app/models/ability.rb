class Ability
  include CanCan::Ability

  def initialize(user, namespace)
    return unless user

    roles = user.permissions.pluck(:role).uniq

    if roles.include?('administrator') && namespace == :administrator
      can :manage,  Permission
      can :read,    Sync
      can :read,    :sidekiq
    end

    if roles.include?('curator') && namespace == :curator
      can :manage, Group
    end

    if roles.include?('dean') && namespace == :dean
      can :read,   Disruption
      can :manage, Miss,       :missing_type => ['Student']
      can :manage, Permission, :context_type => ['Group']
      can :read,   Group
      can :read,   Student
    end

    if roles.include?('education_department') && namespace == :education_department
      can :read,   Faculty
      can :manage, Permission, :context_type => ['Faculty', 'Subdepartment']
      can :read,   Disruption
      can :manage, Miss,       :missing_type => ['Lecturer']
      can :read,   Lecturer
    end

    if roles.include?('group_leader') && namespace == :group_leader
      can :manage, Lesson
      can :read,   Group
      can [:change, :check_all, :uncheck_all], Presence
      can :change, Realize
    end

    if roles.include?('lecturer') && namespace == :lecturer
      can :read,   Disruption
      can :read,   Group
    end

    if roles.include?('subdepartment') && namespace == :subdepartment
      can :read,   Disruption
      can :read,   Group
    end
  end
end
