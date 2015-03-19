class Statistic::Writer < Statistic::Base
  attr_accessor :item

  def initialize(item)
    self.item = item
  end

  def redis
    @redis ||= Statistic::RedisWriter.instance
  end

  def decr_attendance
    calc_('attendance', :decr)
  end

  def decr_total
    calc_('total', :decr)
  end

  def incr_attendance
    calc_('attendance', :incr)
  end

  def incr_total
    calc_('total', :incr)
  end

  private

  def calc_(kind, operation)
    redis.connection.pipelined do |r|
      send operation, "student:#{item['contingent_id']}:dates",                                  "#{item['date_on']}:#{kind}"
      send operation, "student:#{item['contingent_id']}:disciplines",                            "#{item['discipline']}:#{item['date_on']}:#{kind}"

      send operation, "group:#{item['group']}:dates",                                            "#{item['date_on']}:#{kind}"
      send operation, "group:#{item['group']}:students",                                         "#{item['student']}:#{item['date_on']}:#{kind}"

      send operation, "subdepartment:#{item['subdepartment']}:dates",                            "#{item['date_on']}:#{kind}"
      send operation, "subdepartment:#{item['subdepartment']}:courses",                          "#{item['course']}:#{item['date_on']}:#{kind}"
      send operation, "subdepartment:#{item['subdepartment']}:#{item['course']}:dates",          "#{item['date_on']}:#{kind}"
      send operation, "subdepartment:#{item['subdepartment']}:#{item['course']}:groups",         "#{item['group']}:#{item['date_on']}:#{kind}"
      send operation, "subdepartment:#{item['subdepartment']}:groups",                           "#{item['group']}:#{item['date_on']}:#{kind}"

      send operation, "faculty:#{item['faculty']}:dates",                                        "#{item['date_on']}:#{kind}"
      send operation, "faculty:#{item['faculty']}:courses",                                      "#{item['course']}:#{item['date_on']}:#{kind}"
      send operation, "faculty:#{item['faculty']}:subdepartments",                               "#{item['subdepartment']}:#{item['date_on']}:#{kind}"
      send operation, "faculty:#{item['faculty']}:#{item['course']}:dates",                      "#{item['date_on']}:#{kind}"
      send operation, "faculty:#{item['faculty']}:#{item['course']}:subdepartments",             "#{item['subdepartment']}:#{item['date_on']}:#{kind}"
      send operation, "faculty:#{item['faculty']}:#{item['course']}:groups",                     "#{item['group']}:#{item['date_on']}:#{kind}"

      send operation, "university::dates",                                                       "#{item['date_on']}:#{kind}"
      send operation, "university::courses",                                                     "#{item['course']}:#{item['date_on']}:#{kind}"
      send operation, "university::faculties",                                                   "#{item['faculty']}:#{item['date_on']}:#{kind}"
      send operation, "university:#{item['faculty']}:courses",                                   "#{item['course']}:#{item['date_on']}:#{kind}"
      send operation, "university:#{item['course']}:dates",                                      "#{item['date_on']}:#{kind}"
      send operation, "university:#{item['course']}:faculties",                                  "#{item['faculty']}:#{item['date_on']}:#{kind}"

      item['lecturers'].split(', ').map{|s| s.match(/([[:alpha:]]+\s?)+/).to_s}.each do |lecturer|
        send operation, "lecturer:#{lecturer}:disciplines",                                      "#{item['discipline']}:#{item['date_on']}:#{kind}"
        send operation, "lecturer:#{lecturer}:#{item['discipline']}:dates",                      "#{item['date_on']}:#{kind}"
        send operation, "lecturer:#{lecturer}:#{item['discipline']}:groups",                     "#{item['group']}:#{item['date_on']}:#{kind}"
        send operation, "lecturer:#{lecturer}:#{item['discipline']}:#{item['group']}:dates",     "#{item['date_on']}:#{kind}"
        send operation, "lecturer:#{lecturer}:#{item['discipline']}:#{item['group']}:students",  "#{item['student']}:#{item['date_on']}:#{kind}"

        #faculty lecturers statistic
        send operation, "faculty:#{item['faculty']}:lecturers",                                                     "#{lecturer}:#{item['date_on']}:#{kind}"
        send operation, "lecturer:#{lecturer}:#{item['faculty']}:disciplines",                                      "#{item['discipline']}:#{item['date_on']}:#{kind}"
        send operation, "lecturer:#{lecturer}:#{item['faculty']}:#{item['discipline']}:dates",                      "#{item['date_on']}:#{kind}"
        send operation, "lecturer:#{lecturer}:#{item['faculty']}:#{item['discipline']}:groups",                     "#{item['group']}:#{item['date_on']}:#{kind}"
        send operation, "lecturer:#{lecturer}:#{item['faculty']}:#{item['discipline']}:#{item['group']}:dates",     "#{item['date_on']}:#{kind}"
        send operation, "lecturer:#{lecturer}:#{item['faculty']}:#{item['discipline']}:#{item['group']}:students",  "#{item['student']}:#{item['date_on']}:#{kind}"

        #subdepartment lecturers statistic
        send operation, "subdepartment:#{item['subdepartment']}:lecturers",                                               "#{lecturer}:#{item['date_on']}:#{kind}"
        send operation, "lecturer:#{lecturer}:#{item['subdepartment']}:disciplines",                                      "#{item['discipline']}:#{item['date_on']}:#{kind}"
        send operation, "lecturer:#{lecturer}:#{item['subdepartment']}:#{item['discipline']}:dates",                      "#{item['date_on']}:#{kind}"
        send operation, "lecturer:#{lecturer}:#{item['subdepartment']}:#{item['discipline']}:groups",                     "#{item['group']}:#{item['date_on']}:#{kind}"
        send operation, "lecturer:#{lecturer}:#{item['subdepartment']}:#{item['discipline']}:#{item['group']}:dates",     "#{item['date_on']}:#{kind}"
        send operation, "lecturer:#{lecturer}:#{item['subdepartment']}:#{item['discipline']}:#{item['group']}:students",  "#{item['student']}:#{item['date_on']}:#{kind}"
      end
    end
  end
end
