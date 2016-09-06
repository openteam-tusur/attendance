require 'open-uri'
require 'lecturer_permissions'
require 'progress_bar'

class LessonCatcher
  attr_accessor :starts_at, :ends_at

  def initialize(starts_at=Date.today, ends_at=Date.today)
    self.starts_at = starts_at
    self.ends_at = ends_at
  end

  def sync
    (starts_at..ends_at).each do |date|
      puts "синхронизируем занятия за  #{I18n.l(date)}"
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
      timetable_at = timetable_at date
      pb = ProgressBar.new(timetable_at.count)
      timetable_at.each do |group_number, lessons|
        import_lessons_for(group_number, lessons, date)
        pb.increment!
      end
    end

    def import_lessons_for(group_number, lessons, date)
        lessons.each do |lesson|
          next if lesson['lecturers'].empty?

          lesson_id = nil
          discipline = import_discipline(lesson['discipline']['title'], lesson['discipline']['abbr'])
          begin
            group      = Group.find_by!(:number => group_number)
          rescue ActiveRecord::RecordNotFound
            raise "Не найдена группа #{group_number}"
          end

          Lesson.find_or_initialize_by(:timetable_id => lesson['timetable_id'].to_s, :date_on => date, :group_id => group.id).tap do |l|
            l.classroom    = lesson['classroom']
            l.kind         = lesson['kind']
            l.order_number = lesson['order_number']
            l.discipline   = discipline
            l.deleted_at   = nil
            l.save!
            lesson_id = l.id
          end

          lesson['lecturers'].each do |lecturer|
            begin
              sub_title = lecturer['subdepartment']
              unless sub_title
                Sync.create title: "#{lecturer.inspect} - не указана кафедра",
                            state: :failure
                raise ActiveRecord::RecordNotFound
              end
              search_array = [ sub_title, wrong_abbrs[sub_title],
                               sub_title.mb_chars.downcase.to_s]
              subdepartment = Subdepartment.find_by abbr: search_array
              raise ActiveRecord::RecordNotFound unless subdepartment
            rescue ActiveRecord::RecordNotFound
              raise "Не найдена кафедра #{lecturer['subdepartment']}"
            end
            # safe lecturer import
            lect = Lecturer.find_or_initialize_by(:surname => lecturer['lastname'].squish,
                                                  :name => lecturer['firstname'].squish,
                                                  :patronymic => lecturer['middlename'].squish.presence || nil)

            lect.directory_id = lecturer['directory_id']

            unless lect.subdepartments.include?(subdepartment)
              lect.subdepartments.clear if lect.persisted?
              lect.subdepartments << subdepartment
            end

            begin
              lect.save!
              LecturerPermissions.new(lect, lecturer['emails']).permissions_query if lecturer['emails'].present?
              Realize.find_or_create_by(:lecturer_id => lect.id, :lesson_id => lesson_id)
            rescue
                Sync.create title: "Возникли проблемы с преподавателем #{lect.short_name}",
                            state: :failure
            end
          end

          group.students_at(date).map(&:id).each do |student_id|
            Presence.find_or_create_by(:student_id => student_id, :lesson_id => lesson_id)
          end
        end
    end

    def import_discipline(title, abbr)
      Discipline.find_or_create_by title: title.squish, abbr: abbr.squish
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

    def wrong_abbrs
      {
        'ФС' => 'ФиС',
        'ПМиИ' => 'ПМИ'
      }
    end
end
