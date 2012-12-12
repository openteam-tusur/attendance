# encoding: utf-8

class Faculty < ActiveRecord::Base
  attr_accessible :abbr, :title

  has_many :groups
  has_many :students, :through => :groups
  has_many :presences, :through => :students

  default_scope order(:title)

  delegate :from_last_week, :to => :presences, :prefix => true
  delegate :from_semester_begin, :to => :presences, :prefix => true

  def to_s
    "#{title}(#{abbr})"
  end

  def average_attendance_from_last_week
    "%.1f%" % (groups.count.zero?||presences_from_last_week.count.zero? ? 0 : presences_from_last_week.was.count.to_f*100/presences_from_last_week.count)
  end

  def average_attendance_from_semester_begin
    "%.1f%" % (groups.count.zero?||presences_from_semester_begin.count.zero? ? 0 : presences_from_semester_begin.was.count.to_f*100/presences_from_semester_begin.count)
  end

  def average_attendance_from_last_week_for(course_number)
    "%.1f%" % (groups.count.zero?||presences_from_last_week.where('groups.course = ?', course_number).count.zero? ? 0 : presences_from_last_week.was.where('groups.course = ?', course_number).count.to_f*100/presences_from_last_week.where('groups.course = ?', course_number).count)
  end

  def average_attendance_from_semester_begin_for(course_number)
    "%.1f%" % (groups.count.zero?||presences_from_semester_begin.where('groups.course = ?', course_number).count.zero? ? 0 : presences_from_semester_begin.was.where('groups.course = ?', course_number).count.to_f*100/presences_from_semester_begin.where('groups.course = ?', course_number).count)
  end

  def lose_students(lose_level=0.2)
    results = ActiveRecord::Base.connection.exec_query("
                                              select presences.student_id, count(*) as counter
                                              from presences
                                                join people on people.id = presences.student_id
                                                join groups on people.group_id = groups.id
                                              where presences.kind = 'wasnt'
                                                and presences.date_on between '#{Presence.last_week_begin}' and '#{Presence.last_week_end}'
                                                and faculty_id = #{self.id}
                                                and people.active = 't'
                                              group by student_id
                                              having count(*) >  #{lose_level} * (
                                                select count(*)
                                                from presences p
                                                where p.student_id = presences.student_id
                                                  and p.date_on between '#{Presence.last_week_begin}' and '#{Presence.last_week_end}'
                                              )
                                              order by counter desc
                                             ").rows

    results.map{|student_id, lose_count| Student.find(student_id).tap {|s| s.lose_count = lose_count }}
  end

  def to_param
    abbr
  end
end
