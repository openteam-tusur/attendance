class Statistic::Presentors::PresencePresentor
  attr_accessor :presence

  def initialize(presence)
    @presence = presence
  end

  def data
    {}.tap do |h|
      %w(state date_on student contingent_id group course discipline subdepartment faculty lecturers missed).each do |name|
        h[name] = send name
      end
    end
  end

  def state
    @state ||= presence.state
  end

  def date_on
    @date_on ||= presence.lesson.date_on
  end

  def student
    @student ||= "#{presence.student.surname} #{presence.student.name} #{presence.student.patronymic}"
  end

  def contingent_id
    @contingent_id ||= presence.student.contingent_id
  end

  def group
    @group ||= presence.group
  end

  def course
    @course ||= group.course
  end

  def discipline
    @discipline ||= presence.lesson.discipline.title
  end

  def subdepartment
    @subdepartment ||= group.subdepartment.abbr
  end

  def faculty
    @faculty ||= group.subdepartment.faculty.abbr
  end

  def lecturers
    @lecturers ||= presence.lesson.lecturers.map{ |l| "#{l.surname} #{l.name} #{l.patronymic}" }.join(', ')
  end

  def missed
    @missed ||= presence.missed_by_cause? ? 1 : 0
  end
end
