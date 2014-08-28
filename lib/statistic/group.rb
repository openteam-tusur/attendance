class Statistic::Group < Statistic::Reader
  def uniq_id
    @uniq_id ||= "group:#{context.number}"
  end
end
