class Statistic::Subdepartment < Statistic::Base
  def uniq_id
    @uniq_id ||= "subdepartment:#{context.abbr}"
  end

  def incr_attendance(presence, date_on)
    connection.pipelined do
      connection.hincrby("#{namespace}:#{uniq_id}:by_date",    "#{date_on}:attendance", 1)
      connection.hincrby("#{namespace}:#{uniq_id}:by_group",   "#{presence.lesson.group.number}:#{date_on}:attendance", 1)
      connection.hincrby("#{namespace}:#{uniq_id}:by_course",  "#{presence.lesson.group.course}:#{date_on}:attendance", 1)
    end
  end

  def incr_total(presence, date_on)
    connection.pipelined do
      connection.hincrby("#{namespace}:#{uniq_id}:by_date",    "#{date_on}:total", 1)
      connection.hincrby("#{namespace}:#{uniq_id}:by_group",   "#{presence.lesson.group.number}:#{date_on}:total", 1)
      connection.hincrby("#{namespace}:#{uniq_id}:by_course",  "#{presence.lesson.group.course}:#{date_on}:total", 1)
    end
  end
end
