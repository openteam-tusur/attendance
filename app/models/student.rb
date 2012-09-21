# encoding: utf-8

class Student < Person
  attr_accessible :contingent_id

  belongs_to :group
  has_many :presences
end
