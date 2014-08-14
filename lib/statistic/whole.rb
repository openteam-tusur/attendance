class Statistic::Whole < Statistic::Base
  def uniq_id
    @uniq_id ||= "university"
  end

  def attendance_by_faculties
    res = {}
    Faculty.actual.each do |faculty|
      res.merge! faculty.abbr => Statistic::Faculty.new(faculty).total_attendance
    end
    res
  end
end
