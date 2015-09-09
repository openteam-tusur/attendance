class Statistic::Cleaner < Statistic::Redis
  include Singleton

  def clean(from, to)
    dates = (from..to).map(&:to_s)
    %w(student lecturer group subdepartment faculty university).each do |folder|
      connection.keys("#{namespace}:#{folder}*").each do |key|
        connection.hgetall(key).each do |v_key, value|
          connection.hdel(key, v_key) if dates.include?(v_key.match(/\d{4}-\d{2}-\d{2}/).to_a[0])
        end
      end
    end
  end
end
