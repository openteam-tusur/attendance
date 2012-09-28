# encoding: utf-8

class Faculty < ActiveRecord::Base
  attr_accessible :abbr, :title

  has_many :groups
  has_many :students, :through => :groups

  default_scope order(:title)

  def to_s
    "#{title}(#{abbr})"
  end

  def average_attendance_from_last_week
    "%.1f%" % (groups.count.zero? ? 0 : groups.map(&:average_attendance_from_last_week).map(&:to_f).sum/groups.count)
  end

  def average_attendance_from_semester_begin
    "%.1f%" % (groups.count.zero? ? 0 : groups.map(&:average_attendance_from_semester_begin).map(&:to_f).sum/groups.count)
  end

  def to_param
    abbr
  end
end
