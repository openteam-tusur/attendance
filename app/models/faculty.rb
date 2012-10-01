# encoding: utf-8

class Faculty < ActiveRecord::Base
  attr_accessible :abbr, :title

  has_many :groups
  has_many :students, :through => :groups
  has_many :presences, :through => :students

  default_scope order(:title)

  def to_s
    "#{title}(#{abbr})"
  end

  def average_attendance_from_last_week
    "%.1f%" % (groups.count.zero? ? 0 : presences.was.starts(last_week_begin).ends(last_week_end).count.to_f*100/presences.starts(last_week_begin).ends(last_week_end).count)
  end

  def average_attendance_from_semester_begin
    "%.1f%" % (groups.count.zero? ? 0 : presences.was.starts(semester_begin).count.to_f*100/presences.starts(semester_begin).count)
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
      return Time.zone.parse("#{today.year}-09-01").to_date
    elsif today.month >= 2 && today.month <= 7
      return Time.zone.parse("#{today.year}-02-01").to_date
    end
  end

  def to_param
    abbr
  end
end
