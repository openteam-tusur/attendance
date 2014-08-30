every :day, :at => '4:00am' do
  rake 'sync:lessons'
end

every 1.hours do
  rake 'statistic:calculate'
end
