class Statistic::Student < Statistic::Base
  def uniq_id
    @uniq_id ||= "student:#{context.contingent_id}"
  end
end
