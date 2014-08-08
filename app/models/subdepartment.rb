class Subdepartment < ActiveRecord::Base
  belongs_to  :faculty
  has_many    :groups,          :dependent => :destroy
  has_many    :permissions,     :as => :context, :dependent => :destroy
  has_many    :memberships,     :as => :participate,          :dependent => :destroy
  has_many    :lecturers,       -> { where(:memberships => { :person_type => 'Lecturer' }) }, :through => :memberships, :foreign_key => :person_id, :dependent => :destroy

  validates_uniqueness_of :title, :scope => :abbr
  normalize_attribute :title

  scope :actual,      -> { where(:deleted_at => nil) }
  scope :not_actual,  -> { where.not(:deleted_at => nil) }

  def to_s
    abbr
  end
end
