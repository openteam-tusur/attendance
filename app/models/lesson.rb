# encoding: utf-8

class Lesson < ActiveRecord::Base
  include Enumerize

  attr_accessible :classroom, :date_on, :kind, :order_number, :timetable_id, :presences_attributes, :group_id, :state

  belongs_to :discipline
  belongs_to :group
  belongs_to :lecturer
  has_many :realizes
  has_many :presences
  has_many :lecturers, :through => :realizes

  enumerize :kind, :in => [:lecture, :practice, :laboratory, :research, :design]
  enumerize :state, :in => [:took_place, :wasnt_took_place], :default => :took_place, predicates: true

  default_scope order(:order_number)

  default_value_for :state, :took_place

  scope :by_date, ->(date){ where(:date_on => Time.zone.parse(date).to_date) }
  scope :took_place, where(:state => :took_place)
  scope :from_last_week, ->{ where('lessons.date_on >= ? and lessons.date_on <= ?', Presence.last_week_begin, Presence.last_week_end) }
  scope :from_semester_begin, ->{ where('lessons.date_on >= ?', Presence.semester_begin) }

  accepts_nested_attributes_for :presences

  def switch_state
    self.update_attributes! :state => opposite_state
  end

  def state_texts
    Hash[Lesson.enumerized_attributes[:state].options].invert
  end

  def opposite_state
    (self.class.state.values - [self.state]).first
  end
end
