class Faculty < ActiveRecord::Base
  has_many :permissions,    :as => :context, :dependent => :destroy
  has_many :subdepartments, :dependent => :destroy

  validates_uniqueness_of :title
  normalize_attribute :title
end
