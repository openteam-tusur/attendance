class Subdepartment::GroupsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  defaults :finder => :find_by_number

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
    @group = @subdepartment.groups.find_by(:number => params[:id])
    group_statistic = Statistic::Group.new(@group)

    @attendance_by_date = group_statistic.attendance_by_date(**filter_params)
    @attendance_by_students = group_statistic.attendance_by('students', **filter_params)
  end
end
