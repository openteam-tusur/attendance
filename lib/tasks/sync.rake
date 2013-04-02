# encoding: utf-8

require 'open-uri'
require 'progress_bar'

namespace :sync do
  desc 'Получить список факультетов и групп'
  task :f_and_g => :environment do
    groups = JSON.parse(open("#{Settings['timetable.url']}/api/v1/groups.json").read)

    bar = ProgressBar.new(groups['groups'].count)

    groups['groups'].each do |group|
      faculty = Faculty.find_or_create_by_abbr_and_title(:abbr => group['faculty_abbr'], :title => group['faculty_name'])
      faculty.groups.find_or_create_by_number_and_course(:number => group['number'], :course => group['course'])
      bar.increment!
    end

    message = I18n.localize(Time.now, :format => :short) + " Синхронизация факультетов и групп успешно завершена!"
    Airbrake.notify(:error_class => "rake sync:f_and_g", :error_message => message)
  end

  desc 'Синхронизация студентов'
  task :students => :environment do
    bar = ProgressBar.new(Group.count)
    Group.all.each do |group|
      student_hashes = JSON.parse(open("#{Settings['students.url']}/api/v1/students?group=#{URI.encode(group.contingent_number)}").read)

      if student_hashes.empty?
        puts "Группа №#{group.number}: студенты не найдены"

        message = I18n.localize(Time.now, :format => :short) + " Группа №#{group_number}: студенты не найдены"
        Airbrake.notify(:error_class => "rake sync:students", :error_message => message)
      end

      group.students.update_all(:active => false)

      student_hashes.each do |student_hash|
        group.students.find_or_initialize_by_contingent_id(student_hash['study_id']).tap do |student|
          student.surname    =  student_hash['lastname']
          student.name       =  student_hash['firstname']
          student.patronymic =  student_hash['patronymic']
          student.save!
        end

      end

      bar.increment!
    end

    message = I18n.localize(Time.now, :format => :short) + " Синхронизация студентов успешно завершена!"
    Airbrake.notify(:error_class => "rake sync:students", :error_message => message)
  end

  desc 'Синхронизация уроков на предстоящий день'
  task :lessons => :environment do
    LessonSync.new.sync_lessons(Date.today)
  end

  desc 'Синхронизация уроков с START_DATE=%Y-%m-%d по END_DATE=%Y-%m-%d, если нет END_DATE то берется текущий день'
  task :all_lessons => :environment do
    start_date = Date.parse ENV['START_DATE']
    end_date   = ENV['END_DATE'].present? ? Date.parse(ENV['END_DATE']) : Date.today
    (start_date.to_date .. end_date).each do |date|
      puts date
      LessonSync.new.sync_lessons(date)
    end
  end
end

class LessonSync
  def sync_lessons(date)
    response = JSON.parse(Curl.get("#{Settings['timetable.url']}/api/v1/timetables/by_date/#{date}").body_str)
    bar = ProgressBar.new(response.count)
    response.each do |group_number, lessons|
      if group = Group.find_by_number(group_number)
        lessons.each do |lesson|
          discipline = Discipline.find_or_create_by_abbr_and_title(lesson['discipline'])
          lesson_obj = discipline.lessons.find_or_initialize_by_order_number_and_date_on_and_classroom_and_group_id(
            :order_number => lesson['order_number'].to_s,
            :date_on => date,
            :classroom => lesson['classroom'],
            :group_id => group.id
          ).tap do |item|
            item.kind         = lesson['kind']
            item.timetable_id = lesson['timetable_id']
            item.note         = lesson['note']
            item.save!
          end

          lesson['lecturers'].each do |lecturer|
            lecturer_obj = Lecturer.find_or_create_by_surname_and_name_and_patronymic(
              :surname => lecturer['lastname'].mb_chars.titleize.gsub(/\./, '').strip,
              :name => lecturer['firstname'].mb_chars.titleize.gsub(/\./, '').strip,
              :patronymic => lecturer['middlename'].mb_chars.titleize.gsub(/\./, '').strip
            )

            Realize.find_or_create_by_lecturer_id_and_lesson_id(:lecturer_id => lecturer_obj.id, :lesson_id => lesson_obj.id)
          end

          group.students.pluck(:id).each do |student_id|
            Presence.find_or_create_by_student_id_and_lesson_id(:student_id => student_id, :lesson_id => lesson_obj.id)
          end
        end
      else
        puts "не могу найти группу #{group_number}"

        message = I18n.localize(Time.now, :format => :short) + " При импорте предметов не удалось найти группу #{group_number}."
        Airbrake.notify(:error_class => "rake sync:lessons", :error_message => message)
      end
      bar.increment!
    end

    message = I18n.localize(Time.now, :format => :short) + " Импорт предметов из расписания успешно завершен!"
    Airbrake.notify(:error_class => "rake sync:lessons", :error_message => message)
  end
end
