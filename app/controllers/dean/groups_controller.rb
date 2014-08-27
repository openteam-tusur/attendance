class Dean::GroupsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  defaults :finder => :find_by_number

  def index
    @faculty = current_user.faculties.first
    @groups  = current_user.faculty_groups
    faculty_statistic = Statistic::Faculty.new(@faculty)
    @attendance_by_date = faculty_statistic.attendance_by_date(**filter_params)
    @attendance_by_group = faculty_statistic.attendance_by('groups', **filter_params)
    @attendance_by_course = faculty_statistic.attendance_by('courses', **filter_params)
    @attendance_by_subdepartment = faculty_statistic.attendance_by('subdepartments', **filter_params)
  end

  def show
    @faculty = current_user.faculties.first
    @group = @faculty.groups.find_by(:number => params[:id])
    group_statistic = Statistic::Group.new(@group)

    @attendance_by_date = group_statistic.attendance_by_date(**filter_params)
    @attendance_by_students = group_statistic.attendance_by('students', **filter_params)
  end
end
