class Statistic::Faculty < Statistic::Base
  def uniq_id
    @uniq_id ||= "faculty:#{context.abbr}"
  end

  def incr_attendance(presence, date_on)
    incr('by_date',  "#{date_on}:attendance")
    incr('by_group', "#{presence.lesson.group.number}:#{date_on}:attendance")
    incr('by_course',"#{presence.lesson.group.course}:#{date_on}:attendance")
  end

  def incr_total(presence, date_on)
    incr('by_date',  "#{date_on}:total")
    incr("by_group", "#{presence.lesson.group.number}:#{date_on}:total")
    incr('by_course',"#{presence.lesson.group.course}:#{date_on}:total")
  end
end
