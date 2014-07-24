require 'open-uri'
require 'progress_bar'

namespace :sync do
  desc 'Синхронизация групп'
  task :all => :environment do
    groups = JSON.parse(open("#{Settings['timetable.url']}/attendance/groups.json").read)

    bar = ProgressBar.new(groups['groups'].count)

    groups['groups'].each do |group|
      students = JSON.parse(open(URI.encode("#{Settings['students.url']}/api/v1/students?group=#{group['number']}")).read)
      if students.empty?
        next
      end

      # Faculty
      faculty_hash ||= students.first['group']['subfaculty']['faculty']
      faculty ||= Faculty.find_or_create_by(:title => faculty_hash['name'], :abbr => faculty_hash['abbr'])

      # Subdepartment
      subdepartment_hash ||= students.first['group']['subfaculty']
      subdepartment ||= faculty.subdepartments.find_or_create_by(:title => subdepartment_hash['name'], :abbr => subdepartment_hash['abbr'])

      # Group
      group_hash ||= students.first['group']
      group ||= subdepartment.groups.find_or_create_by(:course => group_hash['course'], :number => group_hash['number'])

      students.each do |student|
        Student.find_or_initialize_by(:contingent_id => student['study_id']).tap do |s|
          s.surname    = student['lastname']
          s.name       = student['firstname']
          s.patronymic = student['patronymic']

          s.save
        end
      end

      bar.increment!
    end

    Sync.create(:title => 'Синхронизация факультетов, кафедр, групп и студентов завершена')
  end
end
