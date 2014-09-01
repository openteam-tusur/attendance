class Statistic::Base
  def incr(key, field)
    redis.incr(key, field)
  end

  def get_all(key)
    redis.get_all(key)
  end

  def redis
    @redis ||= Statistic::Redis.instance
  end
end
