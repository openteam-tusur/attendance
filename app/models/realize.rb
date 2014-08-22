class Realize < ActiveRecord::Base
  belongs_to :lecturer
  belongs_to :lesson

  has_one :lecturer_declaration,      :class_name => 'LecturerDeclaration'
  has_one :subdepartment_declaration, :class_name => 'SubdepartmentDeclaration'

  after_initialize :set_state

  scope :wasnt,               -> { where(:state => :wasnt) }
  scope :ordered_by_lecturer, -> { joins(:lecturer).joins(:lesson).order('people.surname, lessons.date_on desc')}
  scope :ordered_by_lesson,   -> { joins(:lesson).order('lessons.date_on desc') }
  scope :with_lessons,        -> { includes(:lesson) }
  scope :between_dates,       -> (starts_at, ends_at) { joins(:lesson).where(:lessons => { :date_on => (starts_at..ends_at) }) }

  searchable do
    string(:lecturer) { self.lecturer.to_s }
    string :state
    boolean :approved
    time(:lesson_date) { self.lesson.date_on }
    string(:faculty) { self.lecturer.subdepartments.first.faculty.abbr }
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
