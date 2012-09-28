# encoding: utf-8

class Group < ActiveRecord::Base
  attr_accessible :course, :number

  belongs_to :faculty
  has_many :students
  has_many :lessons
  has_many :presences, :through => :students

  default_scope order('number')

  def to_s
    "гр. #{number}"
  end

  def filled_attendance_at?(date)
    return true if lessons_from(semester_begin).by_date(date).empty?
    lessons_from(semester_begin).by_date(date).flat_map{|l| l.presences.empty? || l.presences.map{|p| p.not_marked?}}.uniq.include?(true)
  end

  def average_attendance_from_semester_begin
    "%.1f%" % (students.count.zero? ? 0 : students.map(&:average_attendance_from_semester_begin).map(&:to_f).sum/students.count)
  end

  def average_attendance_from_last_week
    "%.1f%" % (students.count.zero? ? 0 : students.map(&:average_attendance_from_last_week).map(&:to_f).sum/students.count)
  end

  def last_week_begin
    (Time.zone.today - 1.week).beginning_of_week
  end

  def last_week_end
    last_week_begin.end_of_week
  end

  def semester_begin
    today = Time.zone.today
    if today.month >= 9 && today.month <= 12
      return Time.zone.parse("#{today.year}-09-01")
    elsif today.month >= 2 && today.month <= 7
      return Time.zone.parse("#{today.year}-02-01")
    end
  end

  def lessons_from(date)
    lessons.where('date_on >= ?', date)
  end

  def to_param
    number
  end
end
