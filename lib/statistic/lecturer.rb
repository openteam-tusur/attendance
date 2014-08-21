class Statistic::Lecturer < Statistic::Base
  def uniq_id
    @uniq_id ||= "lecturer:#{context}"
  end

  def incr_attendance(presence, date_on)
    incr('by_group',      "#{presence.lesson.group}:#{date_on}:attendance")
    incr('by_discipline', "#{presence.lesson.discipline}:#{date_on}:attendance")
  end

  def incr_total(presence, date_on)
    incr('by_group',      "#{presence.lesson.group}:#{date_on}:total")
    incr('by_discipline', "#{presence.lesson.discipline}:#{date_on}:total")
  end
end
