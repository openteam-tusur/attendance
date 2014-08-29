class Dean::SubdepartmentsController < AuthController
  include FilterParams
  include DateRange

  def show
    @charts = {}
    @faculty = current_user.faculties.actual.first
    @subdepartment = @faculty.subdepartments.actual.find_by(:abbr => params[:id])

    if params[:course_id]
      @parent_url = dean_course_path(params[:course_id], :filter => params[:filter])
      subdepartment_statistic = Statistic::Subdepartment.new(@subdepartment, "#{current_namespace}/courses/#{params[:course_id]}/subdepartments/#{@subdepartment.abbr}")
      @charts['attendance_by_dates.line']  = subdepartment_statistic.attendance_by_date(**filter_params)
      @charts['attendance_by_groups.bar']  = subdepartment_statistic.attendance_by('groups', **filter_params)
    else
      @parent_url = dean_groups_path(:filter => params[:filter])
      subdepartment_statistic = Statistic::Subdepartment.new(@subdepartment, "#{current_namespace}/subdepartments/#{@subdepartment.abbr}")
      @charts['attendance_by_dates.line']  = subdepartment_statistic.attendance_by_date(**filter_params)
      @charts['attendance_by_courses.bar'] = subdepartment_statistic.attendance_by('courses', **filter_params)
      @charts['attendance_by_groups.bar']  = subdepartment_statistic.attendance_by('groups', **filter_params)
    end

  end
end
