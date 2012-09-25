# encoding: utf-8

class Group < ActiveRecord::Base
  attr_accessible :course, :number

  belongs_to :faculty
  has_many :students
  has_many :lessons

  default_scope order('number')

  def to_s
    "гр. #{number}"
  end

  def filled_attendance_at?(date)
    return true if lessons.by_date(date).empty?
    lessons.by_date(date).flat_map{|l| l.presences.empty? || l.presences.map{|p| p.not_marked?}}.uniq.include?(true)
  end

  def to_param
    number
  end
end
