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

  def average_attendence_from_semester_begin
    average_attendence_from(semester_begin)
  end

  def average_attendence_from_last_week_begin
    average_attendence_from(last_week_begin)
  end

  def average_attendence_from(date)
    return 0 if students.empty?
    attendance = Group
      .joins(:students)
      .joins(:presences)
      .select("DISTINCT(presences.id)")
      .where("groups.id = ? AND presences.date_on >= ? AND presences.kind = 'was'", self.id, date).count

    (attendance.to_f/students.count)/lessons_from(date).count
  end

  def last_week_begin
    (Time.zone.today - 1.week).beginning_of_week
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
