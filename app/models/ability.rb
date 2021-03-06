class Ability
  include CanCan::Ability

  def initialize(user, namespace)
    return unless user

    roles = user.permissions.pluck(:role).uniq

    if (roles.include?('administrator') || roles.include?('education_department') || roles.include?('dean')) && namespace == :search
      can :search,  User
    end

    if roles.include?('administrator') && namespace == :administrator
      can :manage,  Permission
      can :manage,  MissKind
      can :read,    Sync
      can :read,    :sidekiq
    end

    if roles.include?('curator') && namespace == :curator
      can :manage, Group
      can :read,   Lesson
    end

    if roles.include?('dean') && namespace == :dean
      can :read,   Disruption
      can :manage, Miss,       missing_type: ['Student']
      can :manage, Permission, context_type: ['Group', 'Subdepartment']
      can [:read, :list],   Group
      can [:read, :search],   Student
      can :read,   GroupLeader
      can :read,   Lesson
      can [:index, :show], Lecturer
      can :show, Discipline
    end

    if namespace == :education_department || namespace == :filling
      if roles.include?('education_department')
        can [:read, :statistics], Faculty
        can :manage, Permission, context_type: ['Faculty', 'Subdepartment']
        can :manage, Disruption
        can :manage, Miss, missing_type: ['Lecturer']
        can [:manage, :change], Realize
        can [:manage, :change, :check_all, :uncheck_all], Presence
        can :read, Student
        can :read, GroupLeader
        can :manage, MissKind
        can :read, Lesson
      end
      if roles.include?('education_prorektor')
        can [:read, :statistics], Faculty

        cannot [:read, :manage], Permission

        cannot :manage, Disruption
        can :read, Disruption

        cannot :manage, Miss

        cannot [:manage, :accept, :refuse, :change], Realize
        can :read, Realize

        can :read, Student
        can :read, GroupLeader

        cannot :manage, MissKind
        can :read, MissKind

        can :read, Lesson
      end
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
      can :manage, LecturerDeclaration do |lecturer_declaration|
        lecturer_declaration.realize.lecturer == user.lecturers.first
      end
    end

    if roles.include?('subdepartment') && namespace == :subdepartment
      can :read,   Disruption
      can :read,   Group
      can :read,   Lesson
      can [:index, :show], Lecturer
      can :show, Discipline
      can :new,  Permission
      can :manage, Permission, context_type: ['Group'], role: 'curator'

      can :manage, SubdepartmentDeclaration do |subdepartment_declaration|
        subdepartment_declaration.realize.lecturer.subdepartments.include?(user.subdepartments.first)
      end
    end
  end
end
