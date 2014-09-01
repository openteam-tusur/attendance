class GroupLeader::GroupsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  actions :show

  def show
    @charts = {}
    @group = current_user.leaded_groups.actual.first
    group_statistic = Statistic::Group.new(@group, "#{current_namespace}/group")
    @charts['attendance_by_dates.line']   = group_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_students.bar'] = group_statistic.attendance_by('students', **filter_params)
  end
end
