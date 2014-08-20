class GroupLeader::GroupsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  actions :show

  def show
    @group = current_user.leaded_groups.first
    @attendance_by_date = Statistic::Group.new(@group).attendance_by_date(**filter_params)
    @attendance_by_students = Statistic::Group.new(@group).attendance_by_students(**filter_params)
  end
end
