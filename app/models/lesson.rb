# encoding: utf-8

class Lesson < ActiveRecord::Base
  include Enumerize

  attr_accessible :classroom, :date_on, :kind, :order_number, :timetable_id, :presences_attributes, :group_id

  belongs_to :discipline
  belongs_to :group
  belongs_to :lecturer
  has_many :realizes
  has_many :presences
  has_many :lecturers, :through => :realizes

  enumerize :kind, :in => [:lecture, :practice, :laboratory, :research, :design]

  default_scope order(:order_number)

  scope :by_date, ->(date){ where(:date_on => Time.zone.parse(date)) }

  accepts_nested_attributes_for :presences
end
