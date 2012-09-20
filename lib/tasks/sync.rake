# encoding: utf-8

require 'curb'
require 'progress_bar'

desc 'Получить список факультетов и групп'
task :sync_f_and_g => :environment do
  groups = JSON.parse(Curl.get("#{Settings['timetable.url']}/api/v1/groups.json").body_str)

  bar = ProgressBar.new(groups['groups'].count)

  groups['groups'].each do |group|
    faculty = Faculty.find_or_create_by_abbr_and_title(:abbr => group['faculty_abbr'], :title => group['faculty_name'])
    faculty.groups.find_or_create_by_number_and_course(:number => group['number'], :course => group['course'])

    bar.increment!
  end
end
