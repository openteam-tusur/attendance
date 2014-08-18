class GroupLeader
  attr_accessor :faculty
  def who_unfilled
    faculty.groups.joins(:group_leaders).select{ |g| g.absent_days > 0 }.map{|g| [g.number, g.group_leaders.first, g.absent_days]}.sort_by{|item| item.first}
  end
end
