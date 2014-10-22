class Statistic::RedisReader < Statistic::Redis
  def timestamp
    connection.select(1)
    @timestamp = connection.get('attendance:statistic:timestamp')
    connection.select(0)
    @timestamp
  end
end
