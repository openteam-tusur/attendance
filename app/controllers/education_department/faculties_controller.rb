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
    @faculty = Faculty.actual.find_by(:abbr => params[:id])
    @charts = {}

    if params[:course_id]
      @course = params[:course_id]

      @parent_url = education_department_course_path(@course, :filter => params[:filter])

      faculty_groups = @faculty.groups.actual.by_course(@course).pluck(:number)
      @charts['attendance_by_dates.line'] = Statistic::Faculty.new(@faculty, nil).attendance_by_date_of_kind('groups', faculty_groups, **filter_params)
      @charts['attendance_by_groups.bar'] = Statistic::Faculty.new(@faculty, current_namespace).attendance_by('groups', **filter_params).select{ |k,v| faculty_groups.include?(k) }
    else
      @parent_url = education_department_faculties_path(:filter => params[:filter])

      faculty_statistic = Statistic::Faculty.new(@faculty, "#{current_namespace}/faculties/#{@faculty.abbr}")
      @charts['attendance_by_dates.line']         = faculty_statistic.attendance_by_date(**filter_params)
      @charts['attendance_by_courses.bar']        = faculty_statistic.attendance_by('courses', **filter_params)
    end
  end
end
