class Realize < ActiveRecord::Base
  attr_accessible :lecturer_id, :lesson_id

  belongs_to :lecturer
  belongs_to :lesson
end
