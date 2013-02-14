require File.expand_path('../directories.rb', __FILE__)

dir = Directories.new

if RUBY_PLATFORM =~ /freebsd/
  set :job_template, "/usr/local/bin/bash -l -i -c ':job' 1>#{dir.log('schedule.log')} 2>#{dir.log('schedule-errors.log')}"
else
  set :job_template, "/bin/bash -l -i -c ':job' 1>#{dir.log('schedule.log')} 2>#{dir.log('schedule-errors.log')}"
end

every :month do
  rake 'sync:f_and_g', :output => { :error => 'error-fg.log', :standard => 'cron-fg.log'}
end

every :sunday, :at => '1am' do
  rake 'sync:students', :output => { :error => 'error-students.log', :standard => 'cron-students.log'}
end

every :day, :at => '4am' do
  rake 'sync:lessons', :output => { :error => 'error-lessons.log', :standard => 'cron-lessons.log'}
end
