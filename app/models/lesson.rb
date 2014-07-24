class Lesson < ActiveRecord::Base
  belongs_to :group
  belongs_to :discipline
  has_many   :presences,  :dependent  => :destroy
  has_many   :students,   :through    => :presences
  has_many   :realizes,   :dependent  => :destroy
  has_many   :lecturers,  :through    => :realizes
end
