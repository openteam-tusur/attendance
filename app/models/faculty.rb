# encoding: utf-8

class Faculty < ActiveRecord::Base
  attr_accessible :abbr, :title

  has_many :groups
  has_many :lessons, :through => :groups
  has_many :students, :through => :groups
  has_many :presences, :through => :students
  has_many :permissions, :foreign_key => :context_id, :conditions => { :context_type => 'Faculty' }

  default_scope order(:title)

  delegate :from_last_week, :to => :presences, :prefix => true
  delegate :from_semester_begin, :to => :presences, :prefix => true

  def faculty_worker_permissions
    permissions.where(:role => :faculty_worker)
  end

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

  def loser_group_leaders(starts_on, ends_on)
    starts_on = starts_on.present? ? starts_on.to_date : Presence.last_week_begin
    ends_on = ends_on.present? ? ends_on.to_date : Presence.last_week_end

    Hash[groups.includes(:group_leaders).map { |g|
        [g, g.presences.joins(:lesson)
         .select('presences.date_on')
         .where("lessons.state = 'took_place'")
         .where('lessons.group_id' => g.id)
         .where("presences.kind = 'not_marked'")
         .where('presences.date_on BETWEEN ? AND ?', starts_on, ends_on).map(&:date_on).uniq.sort]
      }
    ]
  end

  def loser_lecturers(starts_on, ends_on)
    starts_on = starts_on.present? ? starts_on.to_date : Presence.last_week_begin
    ends_on = ends_on.present? ? ends_on.to_date : Presence.last_week_end

    lessons.joins(:lecturers).select('DISTINCT people.surname, lessons.*, groups.number')
      .where("lessons.state='wasnt_took_place' AND lessons.date_on BETWEEN ? AND ?", starts_on, ends_on)
      .group_by{|l| l.lecturers.first}
  end
end
