require 'progress_bar'

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

  # desc 'Импорт посещаемости с sdo.tusur.ru на время карантина'
  # task sdo_presences: :environment do
  #   pb = ProgressBar.new(Group.actual.count)
  #   Group.actual.find_each do |group|
  #     ap group.number
  #     group.lessons.by_date(Date.today - 20.days).order('order_number').each do |lesson|
  #       ap lesson.order_number
  #       lesson_time = LessonTime.new(lesson.order_number, lesson.date_on).lesson_time
  #       ap lesson_time.to_i
  #       pb.increment!
  #     end
  #   end
  # end
end
