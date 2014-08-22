class Statistic::Redis
  include Singleton

  def incr(key, field)
    connection.hincrby("#{namespace}:#{key}", field, 1)
  end

  def get_all(key)
    connection.hgetall("#{namespace}:#{key}")
  end

  def flushdb
    connection.flushdb
  end

  def connection
    @connection ||= Redis.new(:url => Settings['statistic.url'])
  end

  def namespace
    'attendance:statistic'
  end
end
