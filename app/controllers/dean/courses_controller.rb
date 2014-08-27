class Dean::CoursesController < AuthController
  include FilterParams
  include DateRange

  def show
    @faculty = current_user.faculties.first
    @course = params[:id]

    course_groups = @faculty.groups.actual.by_course(@course).pluck(:number)

    faculty_statistic = Statistic::Faculty.new(@faculty)
    @attendance_by_date = faculty_statistic.attendance_by_date_of_kind('courses', @course, **filter_params)
    @attendance_by_group = faculty_statistic.attendance_by('groups', **filter_params).select{ |k,v| course_groups.include?(k) }
  end
end
