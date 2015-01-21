class Statistic::Redis
  include Singleton

  attr_accessor :timestamp

  def set(key, value)
    connection.set("#{namespace}:#{key}", value)
  end

  def incr(key, field)
    connection.hincrby("#{namespace}:#{timestamp}:#{key}", field, 1)
  end

  def decr(key, field)
    connection.hincrby("#{namespace}:#{timestamp}:#{key}", field, -1)
  end

  def get_all(key)
    connection.hgetall("#{namespace}:#{timestamp}:#{key}")
  end

  def connection
    #@connection ||= Redis.new(:path => Settings['statistic.sock'], :driver => :hiredis)
    @connection ||= Redis.new(:url => Settings['statistic.url'], :driver => :hiredis)
  end

  def namespace
    'attendance:statistic'
  end
end
