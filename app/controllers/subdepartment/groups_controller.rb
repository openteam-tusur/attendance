class Subdepartment::GroupsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  def index
    @subdepartment = current_user.subdepartments.first
    @groups        = @subdepartment.groups
    subdepartment_statistic = Statistic::Subdepartment.new(@subdepartment)

    @attendance_by_date = subdepartment_statistic.attendance_by_date(**filter_params)
    @attendance_by_group = subdepartment_statistic.attendance_by('groups', **filter_params)
    @attendance_by_course = subdepartment_statistic.attendance_by('courses', **filter_params)
  end

  def show
    @subdepartment = current_user.subdepartments.first
    @group = @subdepartment.groups.find(params[:id])
  end
end
