class Statistic::Course < Statistic::Reader
  def uniq_id
    @uniq_id ||= "course:#{context}"
  end
end
