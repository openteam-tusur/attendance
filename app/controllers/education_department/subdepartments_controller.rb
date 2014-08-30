class EducationDepartment::SubdepartmentsController < AuthController
  include FilterParams
  include DateRange

  def show
    @charts = {}
    @course = params[:course_id]
    @faculty = params[:faculty_id]
    @subdepartment = params[:id]

    raise params.inspect
    course_statistic = Statistic::Subdepartment.new("#{@subdepartment}:#{@course}", "#{current_namespace}/#{}")

    @charts['attendance_by_dates.line'] = course_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_groups.bar'] = course_statistic.attendance_by('groups', **filter_params)
  end
end
