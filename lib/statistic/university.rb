class Statistic::University < Statistic::Reader
  def uniq_id
    @uniq_id ||= "university"
  end
end
