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
      Sync.create :title => "Синхронизация факультетов и кафедр <span class='success'>прошла успешно.</span> (#{Faculty.actual.where('created_at >= ?', Time.zone.now.utc.to_date).count + Subdepartment.actual.where('created_at >= ?', Time.zone.now.utc.to_date).count} новых)"
    rescue Exception => e
      Sync.create :title => "При синхронизации факультетов и кафедр <span class='failure'>произошла ошибка:</span> \"#{e}\"", :state => :failure
    end
  end

  desc 'Синхронизация групп'
  task :groups => :structure do
    begin
      GroupCatcher.new.sync
      Sync.create :title => "Синхронизация групп <span class='success'>прошла успешно.</span> (#{Group.actual.where('created_at >= ?', Time.zone.now.utc.to_date).count} новых)"
    rescue Exception => e
      Sync.create :title => "При синхронизации групп <span class='failure'>произошла ошибка:</span> \"#{e}\"", :state => :failure
    end
  end

  desc 'Синхронизация студентов'
  task :students => :groups do
    begin
      StudentCatcher.new.sync
      Sync.create :title => "Синхронизация студентов <span class='success'>прошла успешно.</span> (#{Student.actual.where('created_at >= ?', Time.zone.now.utc.to_date).count} новых)"
    rescue Exception => e
      Sync.create :title => "При синхронизации студентов <span class='failure'>произошла ошибка:</span> \"#{e}\"", :state => :failure
    end
  end

  desc 'Синхронизация занятий на предстоящий день'
  task :lessons => :students do
    date = Date.today
    begin
      LessonCatcher.new.sync
      Sync.create :title => "Синхронизация занятий на #{I18n.l(date, :format => '%d %B %Y')} <span class='success'>прошла успешно.</span> (#{Lesson.actual.where(:date_on => date).count} занятий)"
    rescue Exception => e
      Sync.create :title => "При синхронизации занятий на #{I18n.l(date, :format => '%d %B %Y')} <span class='failure'>произошла ошибка:</span> \"#{e}\"", :state => :failure
    end
  end

  desc 'Синхронизация занятий c start по end. %Y-%m-%d'
  task :lessons_by, [:start, :end] => :environment do |t, args|
    abort 'Укажите промежуток дат!' if args.empty? || args['start'].nil? || args['end'].nil?
    dates = args.to_hash.values_at(:start, :end).map{ |d| Date.parse(d) }
    begin
      LessonCatcher.new(*dates).sync
      Sync.create :title => "Синхронизация занятий с #{I18n.l(dates[0], :format => '%d %B %Y')} по #{I18n.l(dates[1], :format => '%d %B %Y')} <span class='success'>прошла успешно.</span> (#{Lesson.actual.where(:date_on => dates[0]..dates[1]).count} занятий)"
    rescue Exception => e
      Sync.create :title => "При синхронизации занятий с #{I18n.l(dates[0], :format => '%d %B %Y')} по #{I18n.l(dates[1], :format => '%d %B %Y')} <span class='failure'>произошла ошибка:</span> \"#{e}\"", :state => :failure
    end
  end
end
