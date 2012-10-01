# encoding: utf-8

class Faculty < ActiveRecord::Base
  attr_accessible :abbr, :title

  has_many :groups
  has_many :students, :through => :groups
  has_many :presences, :through => :students

  default_scope order(:title)

  delegate :from_last_week, :to => :presences, :prefix => true
  delegate :from_semester_begin, :to => :presences, :prefix => true

  def to_s
    "#{title}(#{abbr})"
  end

  def average_attendance_from_last_week
    "%.1f%" % (groups.count.zero? ? 0 : presences_from_last_week.was.count.to_f*100/presences_from_last_week.count)
  end

  def average_attendance_from_semester_begin
    "%.1f%" % (groups.count.zero? ? 0 : presences_from_semester_begin.was.count.to_f*100/presences_from_semester_begin.count)
  end

  def average_attendance_from_last_week_for(course_number)
    "%.1f%" % (groups.count.zero? ? 0 : presences_from_last_week.was.where('groups.course = ?', course_number).count.to_f*100/presences_from_last_week.where('groups.course = ?', course_number).count)
  end

  def average_attendance_from_semester_begin_for(course_number)
    "%.1f%" % (groups.count.zero? ? 0 : presences_from_semester_begin.was.where('groups.course = ?', course_number).count.to_f*100/presences_from_semester_begin.where('groups.course = ?', course_number).count)
  end

  def to_param
    abbr
  end
end
