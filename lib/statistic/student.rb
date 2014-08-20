class Statistic::Student < Statistic::Base
  def uniq_id
    @uniq_id ||= "student:#{context.contingent_id}"
  end

  def incr_attendance(presence, date_on)
    incr('by_date',       "#{date_on}:attendance")
    incr('by_discipline', "#{presence.lesson.discipline.title}:#{date_on}:attendance")
  end

  def incr_total(presence, date_on)
    incr('by_date',       "#{date_on}:total")
    incr("by_discipline", "#{presence.lesson.discipline.title}:#{date_on}:total")
  end
end
