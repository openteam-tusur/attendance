require 'open-uri'
require 'progress_bar'

require 'catchers/structure_catcher'
require 'catchers/group_catcher'
require 'catchers/student_catcher'
require 'catchers/lesson_catcher'

namespace :sync do
  desc 'Синхронизация факультетов, кафедр'
  task :structure => :environment do
    begin
      StructureCatcher.new.sync
      Sync.create :title => 'Синхронизация факультетов и кафедр прошла успешно'
    rescue Exception => e
      Sync.create :title => "При синхронизации факультетов и кафедр произошла ошибка: \"#{e}\"", :state => :failure
    end
  end

  desc 'Синхронизация групп'
  task :groups => :structure do
    begin
      GroupCatcher.new.sync
      Sync.create :title => 'Синхронизация групп прошла успешно'
    rescue Exception => e
      Sync.create :title => "При синхронизации групп произошла ошибка: \"#{e}\"", :state => :failure
    end
  end

  desc 'Синхронизация студентов'
  task :students => :groups do
    begin
      StudentCatcher.new.sync
      Sync.create :title => 'Синхронизация студентов прошла успешно'
    rescue Exception => e
      Sync.create :title => "При синхронизации студентов произошла ошибка: \"#{e}\"", :state => :failure
    end
  end

  desc 'Синхронизация занятий на предстоящий день'
  task :lessons => :students do
    date = Date.today
    begin
      LessonCatcher.new.sync
      Sync.create :title => "Синхронизация занятий на #{date} прошла успешно"
    rescue Exception => e
      Sync.create :title => "При синхронизации занятий на #{date} произошла ошибка: \"#{e}\"", :state => :failure
    end
  end

  desc 'Синхронизация занятий c start по end, если нет end, то берется текущий день. %Y-%m-%d'
  task :lessons_by, [:start, :end] => :environment do |t, args|
    abort 'Укажите промежуток дат!' if args.empty? || args['start'].nil?
    dates = args.to_hash.values.compact.map{ |d| Date.parse(d) }
    begin
      LessonCatcher.new(*dates).sync
      Sync.create :title => "Синхронизация занятий с #{dates[0]} по #{dates[1] || Date.today} прошла успешно. L - #{Lesson.count}, G - #{Group.count}, S - #{Student.count}, L - #{Lecturer.count}, P - #{Presence.count}, R - #{Realize.count}"
    rescue Exception => e
      Sync.create :title => "При синхронизации занятий с #{dates[0]} по #{dates[1] || Date.today} произошла ошибка: \"#{e}\"", :state => :failure
    end
  end
end
