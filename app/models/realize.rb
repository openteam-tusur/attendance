class Realize < ActiveRecord::Base
  belongs_to :lecturer
  belongs_to :lesson
end
