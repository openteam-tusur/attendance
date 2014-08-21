class Statistic::University < Statistic::Base
  def uniq_id
    @uniq_id ||= "university"
  end

  def incr_attendance(presence, date_on)
    incr('by_date',  "#{date_on}:attendance")
    incr('by_course',"#{presence.lesson.group.course}:#{date_on}:attendance")
    incr('by_faculty', "#{presence.lesson.group.subdepartment.faculty.abbr}:#{date_on}:attendance")
    incr('by_subdepartment', "#{presence.lesson.group.subdepartment.abbr}:#{date_on}:attendance")
  end

  def incr_total(presence, date_on)
    incr('by_date',  "#{date_on}:total")
    incr('by_course',"#{presence.lesson.group.course}:#{date_on}:total")
    incr('by_faculty', "#{presence.lesson.group.subdepartment.faculty.abbr}:#{date_on}:total")
    incr('by_subdepartment', "#{presence.lesson.group.subdepartment.abbr}:#{date_on}:total")
  end
end
