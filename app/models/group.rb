class Group < ActiveRecord::Base
  belongs_to :subdepartment
  has_one    :faculty, :through => :subdepartment
  has_many   :permissions,  :as => :context,          :dependent => :destroy
  has_many   :memberships,  :as => :participate,      :dependent => :destroy
  has_many   :students,     -> { where(:memberships => {:deleted_at => nil}).order('surname, name, patronymic') }, :through => :memberships, :source => :person, :source_type => 'Person', :class_name => 'Student'
  has_many   :lessons,      :dependent => :destroy
  has_many   :presences,    :through => :lessons

  validates_presence_of :number
  normalize_attribute :number

  scope :actual,      -> { where(:deleted_at => nil) }
  scope :not_actual,  -> { where.not(:deleted_at => nil) }
  scope :by_course,   -> (c) { where(:course => c) }

  alias_attribute :to_s, :number

  def group_leaders
    Permission.where(:role => :group_leader).flat_map(&:user).compact
  end

  def group_leader
    permission = permissions.where(:role => :group_leader).first
    permission ? permission.user : 'нет старосты'
  end

  def absent_days
    lessons.actual.realized.unfilled.by_semester.map(&:date_on).uniq.count
  end
end
