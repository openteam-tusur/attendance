class GroupLeader
  attr_accessor :faculty
  def initialize(faculty)
    self.faculty = faculty
  end

  def who_unfilled(filter)
    faculty.groups.select{ |g| g.absent_days(filter[:from], filter[:to]) > 0 && g.group_leaders.any? }.map{|g| [g.number, g.group_leaders.first, g.absent_days(filter[:from], filter[:to])] }.sort_by{ |item| item.first }
  end
end
