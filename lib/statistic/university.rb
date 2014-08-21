class Statistic::University < Statistic::Base
  def uniq_id
    @uniq_id ||= "university"
  end

  def incr_attendance(presence, date_on)
    connection.pipelined do
      connection.hincrby("#{namespace}:#{uniq_id}:by_date",    "#{date_on}:attendance", 1)
      connection.hincrby("#{namespace}:#{uniq_id}:by_course",  "#{presence.lesson.group.course}:#{date_on}:attendance", 1)
      connection.hincrby("#{namespace}:#{uniq_id}:by_faculty", "#{presence.lesson.group.subdepartment.faculty.abbr}:#{date_on}:attendance", 1)
      connection.hincrby("#{namespace}:#{uniq_id}:by_subdepartment",   "#{presence.lesson.group.subdepartment.abbr}:#{date_on}:attendance", 1)
    end
  end

  def incr_total(presence, date_on)
    connection.pipelined do
      connection.hincrby("#{namespace}:#{uniq_id}:by_date",    "#{date_on}:total", 1)
      connection.hincrby("#{namespace}:#{uniq_id}:by_course",  "#{presence.lesson.group.course}:#{date_on}:total", 1)
      connection.hincrby("#{namespace}:#{uniq_id}:by_faculty", "#{presence.lesson.group.subdepartment.faculty.abbr}:#{date_on}:total", 1)
      connection.hincrby("#{namespace}:#{uniq_id}:by_subdepartment",   "#{presence.lesson.group.subdepartment.abbr}:#{date_on}:total", 1)
    end
  end
end
