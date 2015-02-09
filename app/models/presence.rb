class Presence < ActiveRecord::Base
  belongs_to :student
  belongs_to :lesson
  has_one :group, :through => :lesson

  scope :by_student,    -> (student)            { find_by(:student_id => student.id) }
  scope :by_state,      -> (state)              { where(:state => state) }
  scope :between_dates, -> (starts_at, ends_at) { joins(:lesson).where(:lessons => { :date_on => (starts_at..ends_at) }) }

  after_commit :set_statistic

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
    if previous_changes.any?
      presentator = Statistic::Presentors::PresencePresentor.new(self).data
      writer = Statistic::Writer.new(presentator)
      prev_value, new_value = previous_changes['state']

      case prev_value
        when 'was'
          return if missed_by_cause?
          writer.decr_attendance
          writer.decr_total         if new_value.nil?
        when 'wasnt'
          return if missed_by_cause?
          writer.incr_attendance    if new_value == 'was'
          writer.decr_total         if new_value.nil?
        when nil
          writer.incr_attendance    if new_value == 'was' || (missed_by_cause? && new_value == 'wasnt')
          writer.incr_total unless new_value.nil?

          #################
          if new_value.nil?
            if missed_by_cause?
              if state == 'wasnt'
                writer.incr_attendance
              end
            else
              if state == 'wasnt'
                writer.decr_attendance
              end
            end
          end
      end
    end
  end
end
