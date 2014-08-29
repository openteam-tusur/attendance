class Dean::CoursesController < AuthController
  include FilterParams
  include DateRange

  def show
    @charts = {}
    @faculty = current_user.faculties.actual.first
    @course  = params[:id]

    faculty_groups = @faculty.groups.actual.by_course(@course).pluck(:number)
    faculty_statistic = Statistic::Faculty.new(@faculty, current_namespace)

    if params[:subdepartment_id]
      @subdepartment = Subdepartment.actual.find_by(:abbr => params[:subdepartment_id])
      @parent_url = dean_subdepartment_path(@subdepartment.abbr, :filter => params[:filter])
    else
      @parent_url = dean_groups_path(:filter => params[:filter])
    end

    @charts['attendance_by_dates.line'] = faculty_statistic.attendance_by_date_of_kind('courses', @course, **filter_params)
    @charts['attendance_by_groups.bar'] = faculty_statistic.attendance_by('groups', **filter_params).select{ |k,v| faculty_groups.include?(k) }
  end
end
