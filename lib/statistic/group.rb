class Statistic::Group < Statistic::Reader
  def uniq_id
    @uniq_id ||= "group:#{context}"
  end
end
