class Statistic::Lecturer < Statistic::Reader
  def uniq_id
    @uniq_id ||= "lecturer:#{context}"
  end
end
