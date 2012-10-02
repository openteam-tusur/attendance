class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    ## common
    can :manage, Context do | context |
      user.manager_of? context
    end

    can :manage, Permission do | permission |
      permission.context && user.manager_of?(permission.context)
    end

    can [:new, :create], Permission do | permission |
      !permission.context && user.manager?
    end

    can [:search, :index], User do
      user.manager?
    end

    can :manage, :application do
      user.have_permissions?
    end

    can :manage, :permissions do
      user.manager?
    end

    can :manage, :audits do
      user.manager_of? Context.first
    end

    ## app specific
    can :manage, :all if user.manager?

    can :read, :university_statistics if user.study_department_worker?

    can :read, Faculty do |faculty|
      user.faculty_worker_of?(faculty)
    end

    can :read, Group do |group|
      can? :read, group.faculty
    end

    can :manage, Presence do |presence|
      can? :read, presence.group
    end

    can [:read, :switch_state], Lesson do |lesson|
      can? :read, lesson.group
    end
  end
end
