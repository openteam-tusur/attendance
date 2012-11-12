# encoding: utf-8

class Student < Person
  attr_accessible :contingent_id, :active

  belongs_to :group
  has_many :presences
  has_many :lessons, :through => :group

  default_value_for :active, true

  default_scope where(:active => true)

  delegate :from_last_week, :to => :presences, :prefix => true
  delegate :from_semester_begin, :to => :presences, :prefix => true
  delegate :number, :to => :group, :prefix => true

  before_save :set_secure_id

  searchable do
    text :surname
    text :name
    text :group_number
  end

  def attendance_on(lesson)
    presences.where(:lesson_id => lesson.id).first
  end

  def attendance_on?(lesson)
    attendance_on(lesson).nil? ? false : attendance_on(lesson).was?
  end

  def attendanced_from_last_week
    presences_from_last_week.was
  end

  def average_attendance_from_last_week
    @average_attendance_from_last_week ||= "%.1f%" % (presences_from_last_week.count.zero? ? 0 : attendanced_from_last_week.count*100/presences_from_last_week.count.to_f)
  end

  def attendanced_from_semester_begin
    presences_from_semester_begin.was
  end

  def average_attendance_from_semester_begin
    @average_attendance_from_semester_begin ||= "%.1f%" % (presences_from_semester_begin.count.zero? ? 0 : attendanced_from_semester_begin.count*100/presences_from_semester_begin.count.to_f)
  end

  def set_secure_id
    self.secure_id = Digest::MD5.hexdigest("#{self.fio}#{self.group_number}")
  end
end
