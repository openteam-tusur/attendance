set :job_template, "bash -c 'source ~/.rvm/environments/default && :job'"

every :day, :at => '4:00am' do
  rake 'sync:lessons'
end

every :day, :at => '5:00am' do
  rake 'statistic:calculate_for_last_month'
end
