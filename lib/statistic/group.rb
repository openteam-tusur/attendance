class Statistic::Group < Statistic::Base
  def uniq_id
    @uniq_id ||= "group:#{context.number}"
  end

  def incr_attendance(presence, date_on)
    incr('by_date',       "#{date_on}:attendance")
    incr('by_student',    "#{presence.student}:#{date_on}:attendance")
  end

  def incr_total(presence, date_on)
    incr('by_date',       "#{date_on}:total")
    incr("by_student",    "#{presence.student}:#{date_on}:total")
  end
end
