class Realize < ActiveRecord::Base
  belongs_to :lecturer
  belongs_to :lesson
  after_initialize :set_state

  scope :wasnt, -> { where(:state => :wasnt) }
  scope :ordered, -> { joins(:lecturer).joins(:lesson).order('people.surname, lessons.date_on desc')}
  scope :with_lessons, -> { includes(:lesson) }

  def to_s
    I18n.t("states.realizes.#{state}")
  end

  def missed_by_cause?
    self.lecturer.misses.by_date(self.lesson.lesson_time).any?
  end

  private
  def set_state
    self.state ||= :was
  end
end
