class Presence < ActiveRecord::Base
  extend Enumerize
  belongs_to :student
  belongs_to :lesson
  has_one :group, :through => :lesson

  enumerize :creator, in: [:group_leader, :sdo], default: :group_leader, predicates: true

  scope :by_student,    -> (student)            { find_by(:student_id => student.id) }
  scope :by_state,      -> (state)              { where(:state => state) }
  scope :between_dates, -> (starts_at, ends_at) { joins(:lesson).where(:lessons => { :date_on => (starts_at..ends_at) }) }

  after_commit :set_statistic, :on => [:update, :destroy]

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
            student_stat= Statistic::Student.new(student.contingent_id, nil).send(:get, 'dates')[lesson.lesson_time.to_date.to_s]
            if missed_by_cause?
              if state == 'wasnt'
                writer.incr_attendance if student_stat.try(:[], 'attendance').to_i < student_stat.try(:[], 'total').to_i
              end
            else
              if state == 'wasnt'
                writer.decr_attendance if student_stat.try(:[], 'attendance').to_i > 0
              end
            end
          end
      end
    end
  end
end

# == Schema Information
#
# Table name: presences
#
#  id         :integer          not null, primary key
#  student_id :integer
#  lesson_id  :integer
#  state      :string(255)
#  created_at :datetime
#  updated_at :datetime
#
