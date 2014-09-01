class Statistic::University < Statistic::Reader
  def uniq_id
    @uniq_id ||= "university:#{context}"
  end
end
