class Lesson < ActiveRecord::Base
  belongs_to :group
  belongs_to :discipline
  has_many   :presences,  :dependent  => :destroy
  has_many   :students,   :through    => :presences
  has_many   :realizes,   :dependent  => :destroy
  has_many   :lecturers,  :through    => :realizes

  scope :by_date,     ->(date) { where(:date_on => date) }
  scope :actual,      ->       { where(:deleted_at => nil) }
  scope :not_actual,  ->       { where.not(:deleted_at => nil) }
  scope :unfilled,    ->       { joins(:presences).where(:presences => { :state => nil }).uniq }
end
