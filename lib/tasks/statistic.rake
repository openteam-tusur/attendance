require 'date_range.rb'
include DateRange
namespace :statistic do
  desc 'Рассчитать всю статистику'

    task clean: "delete:presences_for_deleted_students"

    task clean: :environment do |t, args|
      start = args['start'].blank? ? Date.today : Date.parse(args['start'])
      finish = args['end'].blank? ? Date.today : Date.parse(args['end'])
      p "Очистка статистики"
      Statistic::Cleaner.instance.clean(start, finish)
    end

    desc 'просчитать статистику за последний месяц'
    task :calculate_for_last_month  do
      start = Date.today - 31.day > semester_begin ? Date.today - 31.days : semester_begin
      finish = Date.today
      Rake::Task['statistic:calculate'].invoke("['#{start.to_s}','#{finish.to_s}'")
    end

    task :calculate, [:start, :end] => :clean do |t, args|
    p "Начало обновления статистики"
    start = args['start'].blank? ? Date.today : Date.parse(args['start'])
    finish = args['end'].blank? ? Date.today : Date.parse(args['end'])
    query = "SELECT DISTINCT  presences.state,
                              lessons.date_on,
                              concat_ws(' ', people.surname, people.name, people.patronymic) AS student,
                              people.contingent_id,
                              groups.number AS group,
                              groups.course,
                              disciplines.title as discipline,
                              subdepartments.abbr AS subdepartment,
                              faculties.abbr AS faculty,
                              (SELECT string_agg(lecturers::text, ', ')
                                FROM
                                  (SELECT concat_ws(' ', people.surname, people.name, people.patronymic)
                                    FROM people
                                    LEFT JOIN realizes ON realizes.lecturer_id = people.id
                                    WHERE people.id = realizes.lecturer_id AND realizes.lesson_id = lessons.id) AS lecturers) AS lecturers,
                              (SELECT COUNT(*)
                                FROM misses
                                  WHERE misses.missing_id = people.id AND misses.starts_at <= lessons.date_on AND misses.ends_at >= lessons.date_on) AS missed
             FROM presences
               LEFT JOIN lessons ON presences.lesson_id = lessons.id
               LEFT JOIN realizes ON realizes.lesson_id = lessons.id
               LEFT JOIN people ON people.id = presences.student_id
               LEFT JOIN groups ON lessons.group_id = groups.id
               LEFT JOIN memberships ON  presences.student_id = memberships.person_id AND memberships.participate_id = groups.id AND memberships.participate_type = 'Group'
               LEFT JOIN disciplines ON lessons.discipline_id = disciplines.id
               LEFT JOIN subdepartments ON subdepartments.id = groups.subdepartment_id
               LEFT JOIN faculties ON faculties.id = subdepartments.faculty_id
             WHERE presences.state IS NOT NULL AND lessons.deleted_at IS NULL AND realizes.state = 'was'
               AND lessons.date_on >= '#{start}' AND lessons.date_on <= '#{finish}';"

    res = ActiveRecord::Base.connection.select_all(query)
    abort('Нет данных для обновления') if res.count <= 0
    pb  = ProgressBar.new(res.count)

    res.each do |item|
      writer = Statistic::Writer.new(item)
      writer.incr_attendance if (item['state'] == 'was' || item['missed'].to_i > 0)
      writer.incr_total
      pb.increment!
    end
  end

end
