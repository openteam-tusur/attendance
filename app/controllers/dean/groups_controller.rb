class Dean::GroupsController < AuthController
  include FilterParams
  include DateRange

  load_and_authorize_resource :find_by => :number

  def list
    @faculty = current_user.faculties.first
    @groups = @faculty.groups.group_by(&:course).sort
  end

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
    @discipline = params[:discipline_id]
    @lecturer = params[:lecturer_id]

    if params.to_a[-1][0] == 'id' && params.to_a[-2..-1][0][0] != 'subdepartment_id' && params.to_a[-2..-1][0][0] != 'course_id' && params.to_a[-2..-1][0][0] != 'discipline_id'
      @parent_url = list_dean_groups_path
      group_statistic = Statistic::Group.new(@group, "#{current_namespace}/groups/#{@group}")
    elsif params.to_a[-2..-1][0][0] == 'discipline_id'
      @parent_url = dean_lecturer_discipline_path(@lecturer, @discipline, :filter => params[:filter])
      group_statistic = Statistic::Lecturer.new("#{@lecturer}:#{@faculty}:#{@discipline}:#{@group}", nil)
    elsif params.to_a[-3..-2][0][0] == 'course_id'
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
