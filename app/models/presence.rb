class Presence < ActiveRecord::Base
  belongs_to :student
  belongs_to :lesson
  has_one :group, :through => :lesson

  scope :by_student,    -> (student)            { find_by(:student_id => student.id) }
  scope :by_state,      -> (state)              { where(:state => state) }
  scope :between_dates, -> (starts_at, ends_at) { joins(:lesson).where(:lessons => { :date_on => (starts_at..ends_at) }) }

  after_save :set_statistic

  def change_state
    state.nil? ? self.state = 'was' : state == 'was' ? self.state = 'wasnt' : self.state = 'was'
  end

  def missed_by_cause?
    student.misses.by_date(lesson.lesson_time).count > 0
  end

  def to_s
    I18n.t("states.presences.#{state || :empty}")
  end

  def set_statistic
    if changed?
      presentator = Statistic::Presentors::PresencePresentor.new(self).data
      writer = Statistic::Writer.new(presentator)
      prev_value, new_value = changes['state']

      case prev_value
        when 'was'
          writer.decr_process
          writer.decr_total if new_value.nil?
        when 'wasnt'
          writer.process if new_value == 'was'
          writer.decr_total if new_value.nil?
        when nil
          writer.process if new_value == 'was'
          writer.incr_total
      end
    end
  end
end
