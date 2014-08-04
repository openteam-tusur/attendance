class Group < ActiveRecord::Base
  belongs_to :subdepartment
  has_many   :permissions,                                    :as => :context,          :dependent => :destroy
  has_many   :memberships,                                    :as => :participate,      :dependent => :destroy
  has_many   :students,                                       :through => :memberships, :source => :person, :source_type => 'Student'
  has_many   :people,         -> { order('people.surname') }, :through => :memberships, :source => :person, :source_type => 'Person'
  has_many   :lessons,                                        :dependent => :destroy

  validates_presence_of :number
  normalize_attribute :number

  scope :actual,      -> { where(:deleted_at => nil) }
  scope :not_actual,  -> { where.not(:deleted_at => nil) }

  alias_attribute :to_s, :number

  def group_leader
    permissions.where(:role => :group_leader).first.user
  end

  def absent_days
    lessons.unfilled.by_semester.map(&:date_on).uniq.count
  end
end
