class Statistic::Group < Statistic::Base
  def uniq_id
    @uniq_id ||= "group:#{context.number}"
  end

  def attendance_by_students
    res = {}
    context.students.map do |student|
      res.merge! student.to_s => Statistic::Student.new(student).total_attendance
    end
    res
  end
end
