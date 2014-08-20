class GroupLeader::GroupsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  actions :show

  def show
    @group = current_user.leaded_groups.first
    group_statistic = Statistic::Group.new(@group)
    @attendance_by_date = group_statistic.attendance_by_date(**filter_params)
    @attendance_by_students = group_statistic.attendance_by('by_student', **filter_params)
  end
end
