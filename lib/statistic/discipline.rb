class Statistic::Discipline < Statistic::Reader
  def uniq_id
    @uniq_id ||= "discipline:#{context}"
  end
end
