# encoding: utf-8

class Group < ActiveRecord::Base
  attr_accessible :course, :number

  belongs_to :faculty
  has_many :students
  has_many :lessons
  has_many :presences, :through => :students

  default_scope order('number')
  delegate :semester_begin, :to => :faculty
  delegate :last_week_begin, :to => :faculty
  delegate :last_week_end, :to => :faculty

  def to_s
    "гр. #{number}"
  end

  def filled_attendance_at?(date)
    return true if lessons_from(semester_begin).by_date(date).empty?
    lessons_from(semester_begin).by_date(date).flat_map{|l| l.presences.empty? || l.presences.map{|p| p.not_marked?}}.uniq.include?(true)
  end

  def average_attendance_from_semester_begin
    "%.1f%" % (students.count.zero? ? 0 : presences.was.starts(semester_begin).count.to_f*100 / presences.starts(semester_begin).count)
  end

  def average_attendance_from_last_week
    "%.1f%" % (students.count.zero? ? 0 : presences.was.starts(last_week_begin).ends(last_week_end).count.to_f*100 / presences.starts(last_week_begin).ends(last_week_end).count)
  end

  def lessons_from(date)
    lessons.where('date_on >= ?', date)
  end

  def to_param
    number
  end
end
