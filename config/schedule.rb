every :day, :at => '4:00am' do
  rake 'sync:lessons'
end

every 30.minutes do
  rake 'statistic:calculate'
end
