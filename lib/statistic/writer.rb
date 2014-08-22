class Statistic::Writer < Statistic::Base
  attr_accessor :item

  def initialize(item)
    self.item = item
  end

  def process
    incr_attendance if (item['state'] == 'was' || item['missed'].to_i > 0)
    incr_total
  end

  def incr_attendance
    incr_('attendance')
  end

  def incr_total
    incr_('total')
  end

  private

  def incr_(kind)
    redis.connection.pipelined do
      incr("student:#{item['contingent_id']}:by_date",          "#{item['date_on']}:#{kind}")
      incr("student:#{item['contingent_id']}:by_discipline",    "#{item['discipline']}:#{item['date_on']}:#{kind}")

      incr("group:#{item['group']}:by_date",                    "#{item['date_on']}:#{kind}")
      incr("group:#{item['group']}:by_student",                 "#{item['student']}:#{item['date_on']}:#{kind}")

      incr("subdepartment:#{item['subdepartment']}:by_date",    "#{item['date_on']}:#{kind}")
      incr("subdepartment:#{item['subdepartment']}:by_group",   "#{item['group']}:#{item['date_on']}:#{kind}")
      incr("subdepartment:#{item['subdepartment']}:by_course",  "#{item['course']}:#{item['date_on']}:#{kind}")

      incr("faculty:#{item['faculty']}:by_date",                "#{item['date_on']}:#{kind}")
      incr("faculty:#{item['faculty']}:by_group",               "#{item['group']}:#{item['date_on']}:#{kind}")
      incr("faculty:#{item['faculty']}:by_course",              "#{item['course']}:#{item['date_on']}:#{kind}")

      item['lecturers'].split(', ').map{|s| s.match(/([[:alpha:]]+\s?)+/).to_s}.each do |lecturer|
        incr("lecturer:#{lecturer}:by_group",                   "#{item['group']}:#{item['date_on']}:#{kind}")
        incr("lecturer:#{lecturer}:by_discipline",              "#{item['discipline']}:#{item['date_on']}:#{kind}")
      end

      incr('university:by_date',                                "#{item['date_on']}:#{kind}")
      incr('university:by_course',                              "#{item['course']}:#{item['date_on']}:#{kind}")
      incr('university:by_faculty',                             "#{item['faculty']}:#{item['date_on']}:#{kind}")
      incr('university:by_subdepartment',                       "#{item['subdepartment']}:#{item['date_on']}:#{kind}")
    end
  end
end
