class Presence < ActiveRecord::Base
  belongs_to :student
  belongs_to :lesson
  has_one :group, :through => :lesson

  scope :by_student,    -> (student)            { find_by(:student_id => student.id) }
  scope :by_state,      -> (state)              { where(:state => state) }
  scope :between_dates, -> (starts_at, ends_at) { joins(:lesson).where(:lessons => { :date_on => (starts_at..ends_at) }) }

  def change_state
    state.nil? ? self.state = 'was' : state == 'was' ? self.state = 'wasnt' : self.state = 'was'
  end

  def missed_by_cause?
    student.misses.by_date(lesson.lesson_time).count > 0
  end

  def to_s
    I18n.t("states.presences.#{state || :empty}")
  end
end
