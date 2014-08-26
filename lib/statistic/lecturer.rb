class Statistic::Lecturer < Statistic::Reader
  def uniq_id
    @uniq_id ||= "lecturer:#{context}"
  end

  def route_namespace
    'lecturer'
  end
end
