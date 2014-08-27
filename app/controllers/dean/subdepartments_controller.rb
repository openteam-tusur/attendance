class Dean::SubdepartmentsController < AuthController
  include FilterParams
  include DateRange

  def show
    @faculty = current_user.faculties.first
    @subdepartment = @faculty.subdepartments.find_by(:abbr => params[:id])

    subdepartment_statistic = Statistic::Subdepartment.new(@subdepartment)

    @attendance_by_date = subdepartment_statistic.attendance_by_date(**filter_params)
    @attendance_by_group = subdepartment_statistic.attendance_by('groups', **filter_params)
    @attendance_by_course = subdepartment_statistic.attendance_by('courses', **filter_params)
  end
end
