# encoding: utf-8

class Presence < ActiveRecord::Base
  include Enumerize

  attr_accessible :kind, :lesson_id, :student_id

  belongs_to :lesson
  belongs_to :student
  has_one :group, :through => :student
  has_one :faculty, :through => :group

  before_save :set_date_on

  enumerize :kind, :in => [:not_marked, :valid_excuse, :was, :wasnt], :default => :not_marked, :predicates => true

  scope :was, where(:presences => { :kind => [:was, :valid_excuse] })
  scope :took_place, joins(:lesson).where("lessons.state = 'took_place'")
  scope :from_last_week, ->{ took_place.where('presences.date_on >= ? and presences.date_on <= ?', Presence.last_week_begin, Presence.last_week_end) }
  scope :from_semester_begin, ->{ took_place.where('presences.date_on >= ?', Presence.semester_begin) }

  def to_s
    kind_text
  end

  def self.last_week_begin
    (Time.zone.today - 1.week).beginning_of_week
  end

  def self.last_week_end
    last_week_begin.end_of_week
  end

  def self.semester_begin
    today = Time.zone.today
    if today.month >= 8 && today.month <= 12
      return Time.zone.parse("#{today.year}-09-01").to_date
    elsif today.month >= 1 && today.month <= 7
      return Time.zone.parse("#{today.year}-02-11").to_date
    end
  end

  private
    def set_date_on
      self.date_on = self.lesson.date_on
    end
end
