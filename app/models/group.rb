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

  def to_s
    "гр. #{number}"
  end

  def filled_attendance_at?(date)
    return true if lessons.by_date(date).empty?
    lessons.by_date(date).flat_map{|l| l.presences.empty? || l.presences.map{|p| p.not_marked?}}.uniq.include?(true)
  end

  def average_attendance_from_semester_begin
    "%.1f%" % (students.count.zero? ? 0 : presences_from_semester_begin.was.count.to_f*100 / presences_from_semester_begin.count)
  end

  def average_attendance_from_last_week
    "%.1f%" % (students.count.zero? ? 0 : presences_from_last_week.was.count.to_f*100 / presences_from_last_week.count)
  end

  def to_param
    number
  end
end
