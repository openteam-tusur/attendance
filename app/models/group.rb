# encoding: utf-8

class Group < ActiveRecord::Base
  attr_accessible :course, :number

  belongs_to :faculty
  has_many :students
  has_many :lessons
  has_many :presences, :through => :students

  default_scope order('number')

  delegate :from_last_week, :to => :presences, :prefix => true
  delegate :from_semester_begin, :to => :presences, :prefix => true
  delegate :from_last_week, :to => :lessons, :prefix => true
  delegate :from_semester_begin, :to => :lessons, :prefix => true

  CONTINGENT_GROUP_NUMBERS = {
    '128'   => '128-1',
    '311'   => '311-1',
    '369-1' => '369',
    '910нС' => '910н-с',
    '921нС' => '921н-с'
  }

  def to_s
    "гр. #{number}"
  end

  # TODO: Фиговый фикс student.present?, а все из-за default_scope
  def filled_attendance_at?(date)
    return true if lessons.by_date(date).empty?
    !lessons.took_place.by_date(date).flat_map{|l| l.presences.map{|p| p.not_marked? && p.student.present? }}.uniq.include?(true)
  end

  def nofilled_dates
    lessons_from_semester_begin.took_place.pluck(:date_on).uniq.sort.select{|d| !filled_attendance_at?(d.strftime('%y-%m-%d'))}
  end

  def average_attendance_from_semester_begin
    "%.1f%" % ((students.count.zero? || presences_from_semester_begin.count.zero?) ? 0 : presences_from_semester_begin.was.count.to_f*100 / presences_from_semester_begin.count)
  end

  def average_attendance_from_last_week
    "%.1f%" % ((students.count.zero? || presences_from_last_week.count.zero?) ? 0 : presences_from_last_week.was.count.to_f*100 / presences_from_last_week.count)
  end

  def to_param
    number
  end

  def contingent_number
    CONTINGENT_GROUP_NUMBERS[number] || number
  end
end
