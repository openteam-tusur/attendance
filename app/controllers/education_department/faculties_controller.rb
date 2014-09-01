class EducationDepartment::FacultiesController < AuthController
  include FilterParams
  include DateRange

  load_and_authorize_resource :find_by => :abbr

  def index
    @charts = {}
    university_statistic = Statistic::University.new(nil, current_namespace)
    @charts['attendance_by_dates.line']          = university_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_courses.bar']         = university_statistic.attendance_by('courses', **filter_params)
    @charts['attendance_by_faculties.bar']       = university_statistic.attendance_by('faculties', **filter_params)
  end

  def show
    @charts = {}
    @faculty = Faculty.actual.find_by(:abbr => params[:id])
    @course = params[:course_id]

    if @course
      faculty_statistic = Statistic::Faculty.new("#{@faculty}:#{@course}", "#{current_namespace}/courses/#{@course}/faculties/#{@faculty}")

      @parent_url = education_department_course_path(@course, :filter => params[:filter])

      @charts['attendance_by_dates.line']          = faculty_statistic.attendance_by_date(**filter_params)
      @charts['attendance_by_groups.bar']          = faculty_statistic.attendance_by('groups', **filter_params)
    else
      faculty_statistic = Statistic::Faculty.new(@faculty, "#{current_namespace}/faculties/#{@faculty}")

      @parent_url = education_department_faculties_path(:filter => params[:filter])

      @charts['attendance_by_dates.line']          = faculty_statistic.attendance_by_date(**filter_params)
      @charts['attendance_by_courses.bar']         = faculty_statistic.attendance_by('courses', **filter_params)
    end
  end
end
