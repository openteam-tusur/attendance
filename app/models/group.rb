class Group < ActiveRecord::Base
  belongs_to :subdepartment
  has_many   :permissions,    :as => :context,          :dependent => :destroy
  has_many   :memberships,    :as => :participate,      :dependent => :destroy
  has_many   :students,       :through => :memberships, :source => :person, :source_type => 'Student'
  has_many   :people,         :through => :memberships, :source => :person, :source_type => 'Person'

  validates_presence_of :number
  normalize_attribute :number

  alias_attribute :to_s, :number
end
