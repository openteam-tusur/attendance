class EducationDepartment::FacultiesController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  defaults :finder => :find_by_abbr

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

    if params[:course_id]
      faculty_statistic = Statistic::Faculty.new("#{@faculty}:#{params[:course_id]}", "#{current_namespace}/courses/#{params[:course_id]}/faculties/#{@faculty}")
      @charts['attendance_by_dates.line']          = faculty_statistic.attendance_by_date(**filter_params)
      @charts['attendance_by_groups.bar']          = faculty_statistic.attendance_by('groups', **filter_params)
    else
      faculty_statistic = Statistic::Faculty.new(@faculty, "#{current_namespace}/faculties/#{@faculty}")
      @charts['attendance_by_dates.line']          = faculty_statistic.attendance_by_date(**filter_params)
      @charts['attendance_by_courses.bar']         = faculty_statistic.attendance_by('courses', **filter_params)
    end
  end
end
