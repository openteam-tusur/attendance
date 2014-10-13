class User
  include AuthClient::User
  include TusurHeader::MenuLinks

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

  def associate_pending_permissions
    Permission.where(:email => email).where("user_id IS NULL OR user_id = ''").update_all :user_id => id
  end

  def associate_lecturer
    if try(:directory_id)
      lecturer = Lecturer.find_by(:directory_id => directory_id)
      permissions.find_or_create_by(:role => :lecturer, :context_type => 'Person', :context_id => lecturer.id, :user_id => id)
    else
      permissions.where(:role => :lecturer, :user_id => id).destroy_all
    end
  end

  def student
    @student ||= Student.actual.find_by(:contingent_id => try(:contingent_id))
  end

  def info_hash
    hash = {}

    hash.merge!(:my_url => { :title => 'Мой журнал посещаемости', :link => "#{Settings['app.url']}/lecturer" }) if has_permission?(role: :lecturer)

    if try(:contingent_id) && try(:group_number) && student
      hash.merge!(:my_url => { :title => 'Мой журнал посещаемости', :link => "#{Settings['app.url']}/students/#{student.secure_id}" })
    end

    super.merge(hash)
  end

  def after_signed_in
    associate_pending_permissions
    associate_lecturer
    super
  end
end
