class Faculty < ActiveRecord::Base
  has_many :permissions,    :as => :context, :dependent => :destroy
  has_many :subdepartments, :dependent => :destroy
  has_many :lecturers,      :through => :subdepartments
  has_many :realizes,       :through => :lecturers
  has_many :groups,         :through => :subdepartments
  has_many :presences,      :through => :groups
  has_many :students,       :through => :groups

  validates_uniqueness_of :title, :scope => :abbr
  normalize_attribute :title

  scope :actual,      -> { where(:deleted_at => nil) }
  scope :not_actual,  -> { where.not(:deleted_at => nil) }

  def to_s
    abbr
  end
end
