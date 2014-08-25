class Realize < ActiveRecord::Base
  belongs_to :lecturer
  belongs_to :lesson

  has_one :lecturer_declaration,      :class_name => 'LecturerDeclaration'
  has_one :subdepartment_declaration, :class_name => 'SubdepartmentDeclaration'

  after_initialize :set_state

  extend Enumerize

  enumerize :approved, :in => [:yes, :no, :unfilled], :default => :unfilled, :predicates => true

  scope :wasnt,               -> { where(:state => :wasnt) }
  scope :ordered_by_lecturer, -> { joins(:lecturer).joins(:lesson).order('people.surname, lessons.date_on desc')}
  scope :ordered_by_lesson,   -> { joins(:lesson).order('lessons.date_on desc') }
  scope :with_lessons,        -> { includes(:lesson) }
  scope :between_dates,       -> (starts_at, ends_at) { joins(:lesson).where(:lessons => { :date_on => (starts_at..ends_at) }) }

  searchable do
    string :state
    string :approved
    string(:lecturer) { self.lecturer.to_s }
    string(:faculty) { self.lecturer.actual_subdepartment.faculty.abbr }
    string(:subdepartment_id) { self.lecturer.actual_subdepartment.id }
    time(:lesson_date) { self.lesson.date_on }
  end

  def to_s
    I18n.t("states.realizes.#{state}")
  end

  def missed_by_cause?
    lecturer.misses.by_date(lesson.lesson_time).any?
  end

  private
  def set_state
    self.state ||= :was
  end
end
