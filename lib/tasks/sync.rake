# encoding: utf-8

require 'curb'
require 'progress_bar'

namespace :sync do
  desc 'Получить список факультетов и групп'
  task :f_and_g => :environment do
    groups = JSON.parse(Curl.get("#{Settings['timetable.url']}/api/v1/groups.json").body_str)

    bar = ProgressBar.new(groups['groups'].count)

    groups['groups'].each do |group|
      faculty = Faculty.find_or_create_by_abbr_and_title(:abbr => group['faculty_abbr'], :title => group['faculty_name'])
      faculty.groups.find_or_create_by_number_and_course(:number => group['number'], :course => group['course'])

      bar.increment!
    end
  end

  desc 'Синхронизация студентов'
  task :students => :environment do
    Group.find_each do |group|
      p "Импорт студентов группы #{group.number}"
      students = JSON.parse(Curl.get("#{Settings['students.url']}/students.json?student_search[group]=#{group.number}").body_str)

      bar = ProgressBar.new(students.count)

      p "Студенты не найдены" if students.empty?

      students.each do |student|
        student = student['student']

        group.students.find_or_initialize_by_contingent_id(student['study_id']).tap do |item|
          item.surname    =  student['lastname']
          item.name       =  student['firstname']
          item.patronymic =  student['patronymic']
          item.save!
        end

        bar.increment!
      end
    end
  end
end

desc 'Синхронизация'
task :sync => ['sync:f_and_g', 'sync:students'] do
end
