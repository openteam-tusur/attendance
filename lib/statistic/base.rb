class Statistic::Base
  def incr(key, field)
    redis.incr(key, field)
  end

  def decr(key, field)
    redis.decr(key, field)
  end

  def get_all(key)
    redis.get_all(key)
  end
end
