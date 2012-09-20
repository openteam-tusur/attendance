class Student < Person
  attr_accessible :contingent_id, :name, :patronymic, :surname

  belongs_to :group
  has_many :presences
end
