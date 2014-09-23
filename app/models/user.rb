class User < ActiveRecord::Base
  include Gravtastic
  gravtastic
  has_remote_profile

  has_many :curated_groups, -> { where('permissions.role = ?', :curator) },       :through => :permissions, :source => :context, :source_type => 'Group'
  has_many :leaded_groups,  -> { where('permissions.role = ?', :group_leader) },  :through => :permissions, :source => :context, :source_type => 'Group'
  has_many :lecturers,      -> { where('permissions.role = ?', :lecturer) },      :through => :permissions, :source => :context, :source_type => 'Person',:class_name => 'Lecturer'
  has_many :students,       -> { where('permissions.role = ?', :student) },       :through => :permissions, :source => :context, :source_type => 'Person',:class_name => 'Student'
  has_many :subdepartments, -> { where('permissions.role = ?', :subdepartment) }, :through => :permissions, :source => :context, :source_type => 'Subdepartment'
  has_many :faculties,      -> { where('permissions.role = ?', :dean) },          :through => :permissions, :source => :context, :source_type => 'Faculty'

  alias_attribute :to_s, :short_name

  searchable do
    string :name, :using => :ordered_name
  end

  def after_oauth_authentication
    Permission.where(:email => self.email).each {|p| p.update_attribute(:user_id, self.id) }
  end

  def faculty_groups
    return if permissions.for_role(:dean).empty?
    permissions.for_role(:dean).first.context.groups
  end

  def group
    return if permissions.for_role(:group_leader).empty?
    permissions.for_role(:group_leader).first.context
  end

  def ordered_name
    res = self.name.split(/\s/)

    [res.last, res.first].join(' ')
  end

  def info
    "#{self.ordered_name}, #{self.email}"
  end

  def as_json(options)
    super(:only => :id).merge(:label => info, :value => info)
  end

  def short_name
    res = 'anonymous'

    if name
      fio = name.split(/\s+/)
      case fio.count
      when 1
        res = fio[0]
      when 2
        res = "#{fio[1]} #{fio[0][0]}."
      when 3
        res = "#{fio[2]} #{fio[0][0]}. #{fio[1][0]}."
      else
        res = "#{fio[-1][0]} #{fio[0][0]}."
      end if fio.any?
    end

    res
  end
end
