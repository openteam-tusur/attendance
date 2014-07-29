class Discipline < ActiveRecord::Base
  has_many :permissions, :as => :context, :dependent => :destroy
  has_many :lessons,     :dependent => :destroy

  validates_uniqueness_of :title, :scope => [:abbr]
  normalize_attributes :title, :abbr
end
