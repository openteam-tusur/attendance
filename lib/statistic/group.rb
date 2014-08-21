class Statistic::Group < Statistic::Base
  def uniq_id
    @uniq_id ||= "group:#{context.number}"
  end

  def incr_attendance(presence, date_on)
    connection.pipelined do
      connection.hincrby("#{namespace}:#{uniq_id}:by_date",    "#{date_on}:attendance", 1)
      connection.hincrby("#{namespace}:#{uniq_id}:by_student", "#{presence.student}:#{date_on}:attendance", 1)
    end
  end

  def incr_total(presence, date_on)
    connection.pipelined do
      connection.hincrby("#{namespace}:#{uniq_id}:by_date",    "#{date_on}:total", 1)
      connection.hincrby("#{namespace}:#{uniq_id}:by_student", "#{presence.student}:#{date_on}:total", 1)
    end
  end
end
