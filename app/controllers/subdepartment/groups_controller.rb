class Subdepartment::GroupsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  def index
    @subdepartment = current_user.subdepartments.first
    @groups        = @subdepartment.groups
    @attendance_by_date = Statistic::Subdepartment.new(@subdepartment).attendance_by_date(**filter_params)
    @attendance_by_groups = Statistic::Subdepartment.new(@subdepartment).attendance_by_groups(**filter_params)
  end

  def show
    @subdepartment = current_user.subdepartments.first
    @group = @subdepartment.groups.find(params[:id])
  end
end
