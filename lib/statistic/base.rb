class Statistic::Base
  attr_accessor :context, :presences

  def initialize(context=nil, presences=nil)
    self.context = context
    self.presences = presences
  end

  def process
    pb = ProgressBar.new(presences.count)
    presences.find_each do |presence|
      student       = presence.student
      group         = presence.lesson.group
      subdepartment = presence.lesson.group.subdepartment
      faculty       = presence.lesson.group.subdepartment.faculty
      lesson        = presence.lesson
      date_on       = lesson.date_on
      lecturers     = presence.lesson.realizes.map(&:lecturer).flatten

      statistic_student       = Statistic::Student.new(student, nil)
      statistic_group         = Statistic::Group.new(group, nil)
      statistic_subdepartment = Statistic::Subdepartment.new(subdepartment, nil)
      statistic_faculty       = Statistic::Faculty.new(faculty, nil)
      statistic_university    = Statistic::University.new(nil, nil)
      statistic_lecturers = []
      lecturers.each do |lecturer|
        statistic_lecturers << Statistic::Lecturer.new(lecturer, nil)
      end

      if presence.state == 'was' || presence.student.misses.select{|m| m.starts_at <= date_on && m.ends_at >= date_on }.count > 0
        statistic_student.incr_attendance(presence, date_on)
        statistic_group.incr_attendance(presence, date_on)
        statistic_subdepartment.incr_attendance(presence, date_on)
        statistic_faculty.incr_attendance(presence, date_on)
        statistic_lecturers.each do |l|
          l.incr_attendance(presence, date_on)
        end
        statistic_university.incr_attendance(presence, date_on)
      end

      statistic_student.incr_total(presence, date_on)
      statistic_group.incr_total(presence, date_on)
      statistic_subdepartment.incr_total(presence, date_on)
      statistic_faculty.incr_total(presence, date_on)
      statistic_lecturers.each do |l|
        l.incr_total(presence, date_on)
      end
      statistic_university.incr_total(presence, date_on)

      pb.increment!
    end
  end

  def incr(kind, key)
    connection.hincrby("#{namespace}:#{uniq_id}:#{kind}", "#{key}", 1)
  end

  def attendance_by_date(from: nil, to: nil)
    get('by_date').inject({}) do |h, (k, v)|
      date = Date.parse(k)
      h[k] = (v['attendance'].to_i*100.0/v['total']).round(1) if date >= from && date <= to
      h
    end
  end

  def attendance_by(kind, from: nil, to: nil)
    get(kind).inject({}) do |h, (k, v)|
      res = {'attendance' => 0, 'total' => 0}
      v.inject(res) do |hash, (d, a)|
        date = Date.parse(d)
        next unless date >= from && date <= to
        hash['attendance'] += a['attendance'].to_i
        hash['total']      += a['total'].to_i
        hash
      end
      h[k] = (res['attendance'].to_i*100.0/res['total']).round(1)
      h
    end
  end

  private

  def get(kind)
    res = {}

    get_all(kind).each do |k, v|
      key1, key2, key3 = k.split(':')
      res[key1]  ||= {}
      if key3
        res[key1][key2] ||= {}
        res[key1][key2][key3] = v.to_i
      else
        res[key1][key2] = v.to_i
      end
    end

    res
  end

  def get_all(kind)
    connection.hgetall("#{namespace}:#{uniq_id}:#{kind}")
  end

  def connection
    @connection ||= Redis.new(Settings['redis'])
  end

  def namespace
    'attendance'
  end
end
