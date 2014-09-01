class Statistic::Faculty < Statistic::Reader
  def uniq_id
    @uniq_id ||= "faculty:#{context}"
  end
end
