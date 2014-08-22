class Statistic::Student < Statistic::Reader
  def uniq_id
    @uniq_id ||= "student:#{context.contingent_id}"
  end
end
