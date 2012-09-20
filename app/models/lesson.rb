class Lesson < ActiveRecord::Base
  include Enumerize

  attr_accessible :classroom, :date_on, :kind, :order_number, :timetable_id

  belongs_to :discipline
  belongs_to :group
  belongs_to :lecturer
  has_many :presences

  enumerize :kind, :in => [:lecture, :practice, :laboratory, :research, :design]
end
