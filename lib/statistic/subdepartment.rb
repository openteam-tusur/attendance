class Statistic::Subdepartment < Statistic::Base
  def uniq_id
    @uniq_id ||= "subdepartment:#{context.abbr}"
  end

  def attendance_by_groups
    res = {}
    context.groups.each do |group|
      res.merge! group.number => Statistic::Group.new(group).total_attendance
    end
    res
  end
end
