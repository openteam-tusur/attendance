set :job_template, "bash -c 'source ~/.rvm/environments/default && :job'"

every :day, :at => '4:00am' do
  rake 'sync:lessons'
end

every :day, :at => '8:00am' do
 rake 'statistic:calculate'
end
