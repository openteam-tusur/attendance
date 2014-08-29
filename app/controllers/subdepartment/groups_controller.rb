class Subdepartment::GroupsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  defaults :finder => :find_by_number

  def index
    @charts = {}
    @subdepartment = current_user.subdepartments.actual.first
    subdepartment_statistic = Statistic::Subdepartment.new(@subdepartment, current_namespace)

    @charts['attendance_by_dates.line']  = subdepartment_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_courses.bar'] = subdepartment_statistic.attendance_by('courses', **filter_params)
    @charts['attendance_by_groups.bar']  = subdepartment_statistic.attendance_by('groups', **filter_params)
  end

  def show
    @charts = {}
    @subdepartment = current_user.subdepartments.actual.first
    @group = @subdepartment.groups.actual.find_by(:number => params[:id])
    group_statistic = Statistic::Group.new(@group, nil)

    @parent_url = subdepartment_groups_path(:filter => params[:filter])

    @charts['attendance_by_dates.line']   = group_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_students.bar'] = group_statistic.attendance_by('students', **filter_params)
  end
end
