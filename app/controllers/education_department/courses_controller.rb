class EducationDepartment::CoursesController < AuthController
  include FilterParams
  include DateRange

  def show
    @charts = {}
    @course = params[:id]

    if params[:faculty_id]
      @faculty = Faculty.actual.find_by(:abbr => params[:faculty_id])
      faculty_groups = @faculty.groups.actual.by_course(@course).pluck(:number)
      faculty_statistic = Statistic::Faculty.new(@faculty, current_namespace)
      @charts['attendance_by_dates.line'] = faculty_statistic.attendance_by_date_of_kind('courses', @course, **filter_params)
      @charts['attendance_by_groups.bar'] = faculty_statistic.attendance_by('groups', **filter_params).select{ |k,v| faculty_groups.include?(k) }
    else
      @charts['attendance_by_dates.line']    = Statistic::University.new(nil, nil).attendance_by_date_of_kind('courses', @course, **filter_params)
      @charts['attendance_by_faculties.bar'] = Statistic::Course.new(@course, "#{current_namespace}/courses/#{@course}").attendance_by('faculties', **filter_params)
    end
  end
end
