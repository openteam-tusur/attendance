every :day, :at => '4:00am' do
  rake 'sync:lessons'
end

every :day, :at => '6:00am' do
  rake 'statistic:calculate'
end
