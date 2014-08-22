class Statistic::Faculty < Statistic::Reader
  def uniq_id
    @uniq_id ||= "faculty:#{context.abbr}"
  end
end
