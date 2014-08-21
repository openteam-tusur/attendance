class Statistic::Lecturer < Statistic::Base
  def uniq_id
    @uniq_id ||= "lecturer:#{context}"
  end

  def incr_attendance(presence, date_on)
    connection.pipelined do
      connection.hincrby("#{namespace}:#{uniq_id}:by_group",        "#{presence.lesson.group.number}:#{date_on}:attendance", 1)
      connection.hincrby("#{namespace}:#{uniq_id}:by_discipline",   "#{presence.lesson.discipline.title}:#{date_on}:attendance", 1)
    end
  end

  def incr_total(presence, date_on)
    connection.pipelined do
      connection.hincrby("#{namespace}:#{uniq_id}:by_group",        "#{presence.lesson.group.number}:#{date_on}:total", 1)
      connection.hincrby("#{namespace}:#{uniq_id}:by_discipline",   "#{presence.lesson.discipline.title}:#{date_on}:total", 1)
    end
  end
end
