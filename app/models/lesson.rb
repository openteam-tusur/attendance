class Lesson < ActiveRecord::Base
  include Semester

  belongs_to :group
  belongs_to :discipline
  has_many   :presences,  :dependent  => :destroy
  has_many   :students,   :through    => :presences

  has_many   :realizes,   :dependent  => :destroy do
    def change_state
      new_state = proxy_association.owner.realized? ? :wasnt : :was
      self.update_all(:state => new_state)
    end
  end

  has_many   :lecturers,  :through    => :realizes

  scope :by_date,     ->(date) { where(:date_on => date) }
  scope :actual,      ->       { where(:deleted_at => nil) }
  scope :not_actual,  ->       { where.not(:deleted_at => nil) }
  scope :unfilled,    ->       { joins(:presences).where(:presences => { :state => nil }).uniq }
  scope :by_semester,   ->     { where('date_on > :start_at and date_on < :end_at', :start_at => semester_starts_at, :end_at => Date.today.prev_week.end_of_week)}

  def realized?
    realizes.select(:state).first.state == 'was'
  end
end
