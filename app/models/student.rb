class Student < Person
  has_many :memberships, :as => :person, :dependent => :destroy
  has_many :groups,      :through => :memberships, :source => :participate, :source_type => 'Group'

  has_many :presences,   :dependent => :destroy
  has_many :lessons,     :through => :presences
end
