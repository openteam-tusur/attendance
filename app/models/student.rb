# encoding: utf-8

class Student < Person
  attr_accessible :contingent_id

  belongs_to :group
  has_many :presences
  has_many :lessons, :through => :group

  def attendace_on(lesson)
    presences.where(:lesson_id => lesson.id).first || presences.create(:lesson_id => lesson.id)
  end
end
