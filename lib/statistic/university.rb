class Statistic::University < Statistic::Reader
  def uniq_id
    @uniq_id ||= "university"
  end

  def route_namespace
    'education_department'
  end
end
