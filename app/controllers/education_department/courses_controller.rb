class EducationDepartment::CoursesController < AuthController
  include FilterParams
  include DateRange

  def show
    @course = params[:id]
    @charts = {}

    if params[:faculty_id]
      @faculty = Faculty.actual.find_by(:abbr => params[:faculty_id])
      faculty_groups = @faculty.groups.actual.by_course(@course).pluck(:number)
      @charts['attendance_by_dates.line'] = Statistic::Faculty.new(@faculty, nil).attendance_by_date_of_kind('groups', faculty_groups, **filter_params)
      @charts['attendance_by_groups.bar'] = Statistic::Faculty.new(@faculty, current_namespace).attendance_by('groups', **filter_params).select{ |k,v| faculty_groups.include?(k) }
    else
      @charts['attendance_by_dates.line']    = Statistic::University.new(nil, nil).attendance_by_date_of_kind('courses', @course, **filter_params)
      @charts['attendance_by_faculties.bar'] = Statistic::Course.new(@course, "#{current_namespace}/courses/#{@course}").attendance_by('faculties', **filter_params)
    end
  end
end
