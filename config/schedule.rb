set :job_template, "bash -c 'source ~/.rvm/environments/default && :job'"

every :day, at: '00:15am' do
  rake 'import:associate_lecturers_with_users'
end

every :day, at: '00:30am' do
  rake 'import:associate_students_with_users'
end

every :day, at: '1:00am' do
  rake 'import:sdo_presences'
end

every :day, at: '2:00am' do
  rake 'sync:lessons'
end

every :day, at: '3:00am' do
  rake 'statistic:calculate_for_last_month'
end
