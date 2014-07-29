require 'open-uri'

class LessonCatcher
  def initialize(starts_at, ends_at=Date.today)
    self.starts_at = starts_at
    self.ends_at = ends_at
  end

  def starts_at=(starts_at)
    @starts_at = starts_at
  end

  def starts_at
    @starts_at
  end

  def ends_at=(ends_at)
    @ends_at = ends_at
  end

  def ends_at
    @ends_at
  end

  def sync
    (starts_at..ends_at).each do |date|
      mark_lessons_deleted_at date
      import_timetable_at date
      delete_lessons_marked_at date
    end
  end

  private
    def timetable_at(date)
      JSON.parse(open(timetable_url_with(date)).read)
    end

    def import_timetable_at(date)
      timetable_at(date).each do |group_number, lessons|
        import_lessons_for(group_number, lessons, date)
      end
    end

    def import_lessons_for(group_number, lessons, date)
        lessons.each do |lesson|

          discipline = import_discipline(lesson['discipline']['title'], lesson['discipline']['abbr'])
          group      = Group.find_by(:number => group_number)

          lesson['lecturers'].each do |lecturer|
            subdepartment = Subdepartment.find_by(:abbr => lecturer['subdepartment'])
            if subdepartment
              subdepartment.lecturers.find_or_create_by(:surname => lecturer['lastname'], :name => lecturer['firstname'], :patronymic => lecturer['middlename'])
            else
              p "Кафедра >>#{lecturer['subdepartment']}<< не найдена"
              next
            end
          end

          Lesson.find_or_initialize_by(:timetable_id => lesson['timetable_id'].to_s).tap do |l|
            l.group        = group
            l.classroom    = lesson['classroom']
            l.date_on      = date
            l.kind         = lesson['kind']
            l.order_number = lesson['order_number']
            l.discipline   = discipline
            l.save
          end

        end
    end

    def import_discipline(title, abbr)
      Discipline.find_or_create_by(:title => title, :abbr => abbr)
    end

    def mark_lessons_deleted_at(date)
      Lesson.actual.by_date(date).update_all(:deleted_at => Time.zone.now)
    end

    def delete_lessons_marked_at(date)
      Lesson.not_actual.by_date(date).destroy_all
    end

    def timetable_url_with(date)
      "#{Settings['timetable.url']}/api/v1/timetables/by_date/#{date}"
    end
end
