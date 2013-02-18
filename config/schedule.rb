require File.expand_path('../directories.rb', __FILE__)

dir = Directories.new

if RUBY_PLATFORM =~ /freebsd/
  set :job_template, "/usr/local/bin/bash -l -i -c ':job' 1>#{dir.log('schedule.log')} 2>#{dir.log('schedule-errors.log')}"
else
  set :job_template, "/bin/bash -lic ':job'"
end

every :month do
  rake 'sync:f_and_g', :output => { :error => 'log/error-fg.log', :standard => 'log/cron-fg.log'}
end

every :sunday, :at => '1am' do
  rake 'sync:students', :output => { :error => 'log/error-students.log', :standard => 'log/cron-students.log'}
end

every :day, :at => '4am' do
  rake 'sync:lessons', :output => { :error => 'log/error-lessons.log', :standard => 'log/cron-lessons.log'}
end
