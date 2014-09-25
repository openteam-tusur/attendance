class User
  include AuthClient::User

  def gravatar_url(*args)
    ''
  end

  def app_name
    'attendance'
  end

  def faculty_groups
    return if permissions.for_role(:dean).empty?
    permissions.for_role(:dean).first.context.groups
  end

  def group
    return if permissions.for_role(:group_leader).empty?
    permissions.for_role(:group_leader).first.context
  end

  def method_missing(method, *args, &block)
    case method
    when :curated_groups
      get_collection('Group', :curator)
    when :leaded_groups
      get_collection('Group', :group_leader)
    when :lecturers
      get_collection('Lecturer', :lecturer)
    when :students
      get_collection('Student', :student)
    when :faculties
      get_collection('Faculty', :dean)
    when :subdepartments
      get_collection('Subdepartment', :subdepartment)
    else
      super
    end
  end

  def get_collection(klass, role)
    klass.constantize.joins(:permissions).where(:permissions => { :role => role, :user_id => self.id })
  end
end
