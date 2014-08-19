class Statistic::Faculty < Statistic::Base
  def uniq_id
    @uniq_id ||= "faculty:#{context.abbr}"
  end

  def attendance_by_groups(from: nil, to: nil)
    res = {}
    context.groups.each do |group|
      res.merge! group.number => Statistic::Group.new(group).total_attendance(from: from, to: to)
    end
    res
  end
end
