class Discipline < ActiveRecord::Base
  has_many :permissions, :as => :context, :dependent => :destroy
  has_many :lessons,     :dependent => :destroy
  has_many :groups,      -> { uniq.order('groups.number') }, :through => :lessons

  validates_uniqueness_of :title, :scope => [:abbr]
  normalize_attributes :title, :abbr
end
