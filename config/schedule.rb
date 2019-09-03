set :job_template, "bash -c 'source ~/.rvm/environments/default && :job'"

every :day, at: '2:00am' do
  rake 'sync:lessons'
end

every :day, at: '3:00am' do
  rake 'statistic:calculate_for_last_month'
end
