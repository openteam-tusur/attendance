class User
  include AuthClient::User

  def gravatar_url(*args)
    ''
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

  def activity_notify
    RedisUserConnector.set self.id, 'attendance_last_activity', Time.zone.now.to_i
  end

  def info_notify
    RedisUserConnector.set self.id, 'attendance_info', self.permissions_info.to_json
  end

  def permissions_info
    self.permissions.map {|p| {:role => p.role, :info => p.context.try(:to_s)}}
  end
end
