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

  desc 'Ассоциация преподавателей с пользователями'
  task associate_lecturers_with_users: :environment do
    lecturers = Lecturer.all
    pb = ProgressBar.new lecturers.count
    lecturers.find_each do |lecturer|
      if lecturer.permissions.present?
        lecturer.user_id = lecturer.permissions.first.user_id
        lecturer.save!
      end
      if lecturer.directory_id.present?
        directory_url = URI Settings['directory.url']
        directory_url.path = '/api/persons/' + lecturer.directory_id.to_s
      else
        directory_url = URI Settings['directory.url']
        directory_url.path = '/api/persons/by_fullname/'
        directory_url.path += URI.encode lecturer.full_name
      end
      begin
        request = JSON.parse(RestClient.get directory_url.to_s)
        user_id = ''
        if request.class == Array
          user_id = request[0]['user_id'] if request.any?
        else
          user_id = request['user_id']
        end
        if user_id.present?
          lecturer.user_id = user_id
          lecturer.save!
        end
      rescue
        ap directory_url.to_s
      end
      pb.increment!
    end
  end

  desc 'Импорт посещаемости с sdo.tusur.ru на время карантина'
  task :sdo_presences, [:lesson_date] => :environment do |t, args|
    groups = Group.actual
    lesson_date = args['lesson_date'].blank? ? Date.yesterday : Date.parse(args['lesson_date'])
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
