class GroupedRealizes
  def initialize
    @realizes = Realize.wasnt.with_lessons.ordered_by_lecturer
  end

  def by_faculty
    grouped_hash = faculty_hash
    by_lecturer.each do |lecturer, realizes|
      grouped_hash[lecturer.actual_subdepartment.faculty].merge!(lecturer => realizes)
    end

    grouped_hash
  end

  private

  def by_lecturer
    @by_faculty ||= @realizes.group_by(&:lecturer)
  end

  def faculty_hash
    @faculty_hash ||= {}.tap do |h|
      Faculty.all.each do |f|
        h.merge!(f => {})
      end
    end
  end
end
