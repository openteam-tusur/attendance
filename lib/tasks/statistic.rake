namespace :statistic do
  desc 'Рассчитать всю статистику'
  task :calculate => :environment do
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
               LEFT JOIN disciplines ON lessons.discipline_id = disciplines.id
               LEFT JOIN subdepartments ON subdepartments.id = groups.subdepartment_id
               LEFT JOIN faculties ON faculties.id = subdepartments.faculty_id
             WHERE presences.state IS NOT NULL AND lessons.deleted_at IS NULL AND realizes.state = 'was';"

    res = ActiveRecord::Base.connection.select_all(query)
    pb  = ProgressBar.new(res.count)
    Statistic::Redis.instance.flushdb

    res.each do |item|
      Statistic::Writer.new(item).process
      pb.increment!
    end
  end
end
