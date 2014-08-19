class Group < ActiveRecord::Base
  belongs_to :subdepartment
  has_one    :faculty, :through => :subdepartment
  has_many   :permissions,  :as => :context,          :dependent => :destroy
  has_many   :memberships,  :as => :participate,      :dependent => :destroy
  has_many   :students,     -> { order('surname') }, :through => :memberships, :source => :person, :source_type => 'Person', :class_name => 'Student'
  has_many   :lessons,      :dependent => :destroy
  has_many   :presences,    :through => :lessons
  has_many   :group_leaders, -> { where(:permissions => { :role => :group_leader }) }, :through => :permissions, :source => :user

  validates_presence_of :number
  normalize_attribute :number

  scope :actual,      -> { where(:deleted_at => nil) }
  scope :not_actual,  -> { where.not(:deleted_at => nil) }

  alias_attribute :to_s, :number

  def group_leader
    permission = permissions.where(:role => :group_leader).first
    permission ? permission.user : 'нет старосты'
  end

  def absent_days
    lessons.actual.realized.unfilled.by_semester.map(&:date_on).uniq.count
  end
end
