class Presence < ActiveRecord::Base
  include Enumerize

  attr_accessible :kind

  belongs_to :lesson
  belongs_to :student

  enumerize :kind, :in => [:was, :wasnt]
end
