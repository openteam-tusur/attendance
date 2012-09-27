# encoding: utf-8

class Student < Person
  attr_accessible :contingent_id

  belongs_to :group
  has_many :presences
  has_many :lessons, :through => :group

  default_value_for :active, true

  default_scope where(:active => true)

  def attendance_on(lesson)
    presences.where(:lesson_id => lesson.id).first || presences.create(:lesson_id => lesson.id)
  end

  def attendance_on?(lesson)
    attendance_on(lesson).was?
  end

  def average_attendence
    presences.where("date_on >= ? AND kind = 'was'", group.semester_begin).count/group.lessons_from_semester_begin.count.to_f
  end
end
