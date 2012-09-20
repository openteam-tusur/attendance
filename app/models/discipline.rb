class Discipline < ActiveRecord::Base
  attr_accessible :abbr, :title

  has_many :lessons
end
