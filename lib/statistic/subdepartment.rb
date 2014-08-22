class Statistic::Subdepartment < Statistic::Reader
  def uniq_id
    @uniq_id ||= "subdepartment:#{context.abbr}"
  end
end
