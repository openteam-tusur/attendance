class Dean::GroupsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  defaults :finder => :find_by_number

  def index
    @charts = {}
    @faculty = current_user.faculties.first
    @groups  = @faculty.groups.actual
    faculty_statistic = Statistic::Faculty.new(@faculty, current_namespace)

    @charts['attendance_by_dates.line']          = faculty_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_courses.bar']         = faculty_statistic.attendance_by('courses', **filter_params)
    @charts['attendance_by_subdepartments.bar']  = faculty_statistic.attendance_by('subdepartments', **filter_params)
    @charts['attendance_by_groups.bar']          = faculty_statistic.attendance_by('groups', **filter_params)
  end

  def show
    @charts = {}
    @faculty = current_user.faculties.first
    @group = @faculty.groups.actual.find_by(:number => params[:id])
    group_statistic = Statistic::Group.new(@group, nil)

    if params[:subdepartment_id]
      @subdepartment = Subdepartment.actual.find_by(:abbr => params[:subdepartment_id])
      @parent_url = dean_subdepartment_path(@subdepartment.abbr, :filter => params[:filter])
    else
      @parent_url = dean_groups_path(:filter => params[:filter])
    end

    @charts['attendance_by_dates.line']   = group_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_students.bar'] = group_statistic.attendance_by('students', **filter_params)
  end
end
