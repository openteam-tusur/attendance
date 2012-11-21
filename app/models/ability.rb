class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :manage, :application do
      user.permissions.any?
    end

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

    can :manage, Presence do |presence|
      user.group_leader_of?(presence.group)
    end

    can [:read, :switch_state], Lesson do |lesson|
      user.group_leader_of?(lesson.group)
    end
  end
end
