class Dean::GroupsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  defaults :finder => :find_by_number

  def index
    @charts = {}
    @faculty = current_user.faculties.first
    faculty_statistic = Statistic::Faculty.new(@faculty, current_namespace)

    @charts['attendance_by_dates.line']          = faculty_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_courses.bar']         = faculty_statistic.attendance_by('courses', **filter_params)
    @charts['attendance_by_subdepartments.bar']  = faculty_statistic.attendance_by('subdepartments', **filter_params)
  end

  def show
    @charts = {}
    @faculty = current_user.faculties.first
    @group = @faculty.groups.actual.find_by(:number => params[:id])
    @course = params[:course_id]
    @subdepartment = params[:subdepartment_id]

    if params.to_a[-3..-2][0][0] == 'course_id'
      @parent_url = dean_course_subdepartment_path(@course, @subdepartment, :filter => params[:filter])
      group_statistic = Statistic::Group.new(@group, "#{current_namespace}/courses/#{@course}/subdepartments/#{@subdepartment}/groups/#{@group}")
    else
      @parent_url = dean_subdepartment_course_path(@subdepartment, @course, :filter => params[:filter])
      group_statistic = Statistic::Group.new(@group, "#{current_namespace}/subdepartments/#{@subdepartment}/courses/#{@course}/groups/#{@group}")
    end

    @charts['attendance_by_dates.line']   = group_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_students.bar'] = group_statistic.attendance_by('students', **filter_params)
  end
end
