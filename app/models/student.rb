# encoding: utf-8

class Student < Person
  attr_accessible :contingent_id

  belongs_to :group
  has_many :presences
  has_many :lessons, :through => :group

  default_value_for :active, true

  default_scope where(:active => true)

  before_save :set_secure_id

  searchable do
    string :fio
    string :group_number do
      group.number
    end
  end

  def attendance_on(lesson)
    presences.where(:lesson_id => lesson.id).first
  end

  def attendance_on?(lesson)
    attendance_on(lesson).was?
  end

  def presences_from_last_week
    presences.where('date_on >= ? AND date_on <= ?', group.last_week_begin, group.last_week_end)
  end

  def attendanced_from_last_week
    presences.was.where('date_on >= ? AND date_on <= ?', group.last_week_begin, group.last_week_end)
  end

  def average_attendance_from_last_week
    "%.1f%" % (presences_from_last_week.count.zero? ? 0 : attendanced_from_last_week.count*100/presences_from_last_week.count.to_f)
  end

  def presences_from_semester_begin
    presences.where('date_on >= ?', group.semester_begin)
  end

  def attendanced_from_semester_begin
    presences.was.where('date_on >= ?', group.semester_begin)
  end

  def average_attendance_from_semester_begin
    "%.1f%" % (presences_from_semester_begin.count.zero? ? 0 : attendanced_from_semester_begin.count*100/presences_from_semester_begin.count.to_f)
  end

  def set_secure_id
    self.secure_id = Digest::MD5.hexdigest(self.fio)
  end
end
