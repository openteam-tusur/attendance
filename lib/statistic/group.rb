class Statistic::Group < Statistic::Base
  def uniq_id
    @uniq_id ||= "group:#{context.number}"
  end

  def attendance_by_students(from: nil, to: nil)
    res = {}
    context.students.each do |student|
      res.merge! student.to_s => Statistic::Student.new(student).total_attendance(from: from, to: to)
    end
    res
  end
end
