class Faculty < ActiveRecord::Base
  has_many :permissions,    :as => :context, :dependent => :destroy
  has_many :subdepartments, :dependent => :destroy

  validates_uniqueness_of :title, :scope => :abbr
  normalize_attribute :title

  scope :actual,      -> { where(:deleted_at => nil) }
  scope :not_actual,  -> { where.not(:deleted_at => nil) }

  def to_s
    abbr
  end
end
