class Lecturer < Person
  has_many :memberships,  :as => :person, :dependent => :destroy
  has_many :subdepartments, :through => :memberships, :source => :participate, :source_type => 'Subdepartment'

  has_many :realizes,       :dependent => :destroy
  has_many :lessons,        :through => :realizes

  has_many :misses,         :as => :missing, :dependent => :destroy
end
