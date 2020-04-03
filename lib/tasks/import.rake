require 'progress_bar'
require 'catchers/presence_catcher'

namespace :import do
  desc 'Ассоциация студентов с пользователями в кабинете'
  task associate_students_with_users: :environment do
    students = Student.actual
    pb = ProgressBar.new students.count
    students.each do |student|
      profile_users_url = [
        Settings['profile.url'],
        '/api/v2/users/live_by_study_id?study_id=',
        student.contingent_id
      ].join
      request = RestClient.get profile_users_url
      user_id = JSON.parse(request).first
      student.user_id = user_id
      student.save!
      pb.increment!
    end
  end

  desc 'Импорт посещаемости с sdo.tusur.ru на время карантина'
  task sdo_presences: :environment do
    groups = Group.actual
    lesson_date = Date.today - 1.days
    ap 'синхронизация за ' + lesson_date.to_s
    begin
      PresenceCatcher.new(groups, lesson_date).sync
      Sync.create title: "Импорт посещений за #{I18n.l(lesson_date, format: '%d %B %Y')} <span class='success'>прошел успешно.</span>"
    rescue Exception => e
      Sync.create title: "При импорте посещений за #{I18n.l(lesson_date, format: '%d %B %Y')} <span class='failure'>произошла ошибка:</span> \"#{e}\"", state: :failure
      Airbrake.notify(error_class: "Sync Lessons Rake", error_message: e.message)
    end
  end
end
