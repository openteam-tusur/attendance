class Statistic::Base
  attr_accessor :context, :presences

  def self.flush
    new.flush
  end

  def initialize(context=nil)
    self.context = context
  end

  def calculate_attendance(presences)
    clear
    self.presences = presences

    presences.each do |presence|
      if presence.state == 'was' || presence.missed_by_cause?
        incr_attendance(presence.lesson.date_on)
        incr_total(presence.lesson.date_on)
      elsif presence.state == 'wasnt'
        incr_total(presence.lesson.date_on)
      end
    end
  end

  def total_attendance
    res = get.inject({'attendance' => 0, 'total' => 0}) do |h, (_,v)|
      h['attendance'] += v['attendance'].to_i
      h['total']      += v['total'].to_i
      h
    end

    (res['attendance']*100.0/res['total']).round(1)
  end

  def attendance_by_date
    get.inject({}) do |h, (k, v)|
      h[k] = (v['attendance']*100.0/v['total']).round(1)
      h
    end
  end

  def incr_attendance(date_on)
    connection.hincrby("#{namespace}:#{uniq_id}", "#{date_on}:attendance", 1)
  end

  def incr_total(date_on)
    connection.hincrby("#{namespace}:#{uniq_id}", "#{date_on}:total", 1)
  end

  protected

  def get
    res = {}

    get_all.each do |k, v|
      date, kind = k.split(':')
      res[date]  ||= {}
      res[date][kind] = v.to_i
    end

    res
  end

  def get_all
    connection.hgetall("#{namespace}:#{uniq_id}")
  end

  def clear
    connection.del("#{namespace}:#{uniq_id}")
  end

  private

  def connection
    @connection ||= Redis.new(Settings['redis'])
  end

  def namespace
    'attendance'
  end
end
