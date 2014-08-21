class Statistic::Student < Statistic::Base
  def uniq_id
    @uniq_id ||= "student:#{context.contingent_id}"
  end

  def incr_attendance(presence, date_on)
    connection.pipelined do
      connection.hincrby("#{namespace}:#{uniq_id}:by_date",       "#{date_on}:attendance", 1)
      connection.hincrby("#{namespace}:#{uniq_id}:by_discipline", "#{presence.lesson.discipline.title}:#{date_on}:attendance", 1)
    end
  end

  def incr_total(presence, date_on)
    connection.pipelined do
      connection.hincrby("#{namespace}:#{uniq_id}:by_date",       "#{date_on}:total", 1)
      connection.hincrby("#{namespace}:#{uniq_id}:by_discipline", "#{presence.lesson.discipline.title}:#{date_on}:total", 1)
    end
  end
end
