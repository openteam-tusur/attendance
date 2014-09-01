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
      incr("student:#{item['contingent_id']}:dates",                                  "#{item['date_on']}:#{kind}")
      incr("student:#{item['contingent_id']}:disciplines",                            "#{item['discipline']}:#{item['date_on']}:#{kind}")

      incr("group:#{item['group']}:dates",                                            "#{item['date_on']}:#{kind}")
      incr("group:#{item['group']}:students",                                         "#{item['student']}:#{item['date_on']}:#{kind}")

      incr("subdepartment:#{item['subdepartment']}:dates",                            "#{item['date_on']}:#{kind}")
      incr("subdepartment:#{item['subdepartment']}:courses",                          "#{item['course']}:#{item['date_on']}:#{kind}")
      incr("subdepartment:#{item['subdepartment']}:#{item['course']}:dates",          "#{item['date_on']}:#{kind}")
      incr("subdepartment:#{item['subdepartment']}:#{item['course']}:groups",         "#{item['group']}:#{item['date_on']}:#{kind}")
      incr("subdepartment:#{item['subdepartment']}:groups",                           "#{item['group']}:#{item['date_on']}:#{kind}")

      incr("faculty:#{item['faculty']}:dates",                                        "#{item['date_on']}:#{kind}")
      incr("faculty:#{item['faculty']}:courses",                                      "#{item['course']}:#{item['date_on']}:#{kind}")
      incr("faculty:#{item['faculty']}:subdepartments",                               "#{item['subdepartment']}:#{item['date_on']}:#{kind}")
      incr("faculty:#{item['faculty']}:#{item['course']}:dates",                      "#{item['date_on']}:#{kind}")
      incr("faculty:#{item['faculty']}:#{item['course']}:subdepartments",             "#{item['subdepartment']}:#{item['date_on']}:#{kind}")
      incr("faculty:#{item['faculty']}:#{item['course']}:groups",                     "#{item['group']}:#{item['date_on']}:#{kind}")

      incr("university::dates",                                                       "#{item['date_on']}:#{kind}")
      incr("university::courses",                                                     "#{item['course']}:#{item['date_on']}:#{kind}")
      incr("university::faculties",                                                   "#{item['faculty']}:#{item['date_on']}:#{kind}")
      incr("university:#{item['faculty']}:courses",                                   "#{item['course']}:#{item['date_on']}:#{kind}")
      incr("university:#{item['course']}:dates",                                      "#{item['date_on']}:#{kind}")
      incr("university:#{item['course']}:faculties",                                  "#{item['faculty']}:#{item['date_on']}:#{kind}")

      item['lecturers'].split(', ').map{|s| s.match(/([[:alpha:]]+\s?)+/).to_s}.each do |lecturer|
        incr("lecturer:#{lecturer}:disciplines",                                      "#{item['discipline']}:#{item['date_on']}:#{kind}")
        incr("lecturer:#{lecturer}:#{item['discipline']}:dates",                      "#{item['date_on']}:#{kind}")
        incr("lecturer:#{lecturer}:#{item['discipline']}:groups",                     "#{item['group']}:#{item['date_on']}:#{kind}")
        incr("lecturer:#{lecturer}:#{item['discipline']}:#{item['group']}:dates",     "#{item['date_on']}:#{kind}")
        incr("lecturer:#{lecturer}:#{item['discipline']}:#{item['group']}:students",  "#{item['student']}:#{item['date_on']}:#{kind}")
      end
    end
  end
end
