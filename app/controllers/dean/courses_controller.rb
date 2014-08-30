class Dean::CoursesController < AuthController
  include FilterParams
  include DateRange

  def show
    @charts = {}
    @faculty = current_user.faculties.actual.first
    @course  = params[:id]

    if params[:subdepartment_id]
      @subdepartment = params[:subdepartment_id]
      @parent_url = dean_subdepartment_path(@subdepartment, :filter => params[:filter])
      subdepartment_statistic = Statistic::Subdepartment.new("#{@subdepartment}:#{@course}", "#{current_namespace}/subdepartments/#{@subdepartment}/courses/#{@course}")
      @charts['attendance_by_dates.line']          = subdepartment_statistic.attendance_by_date(**filter_params)
      @charts['attendance_by_groups.bar']          = subdepartment_statistic.attendance_by('groups', **filter_params)
    else
      @parent_url = dean_root_path(:filter => params[:filter])
      faculty_statistic = Statistic::Faculty.new("#{@faculty}:#{@course}", "#{current_namespace}/courses/#{@course}")
      @charts['attendance_by_dates.line']          = faculty_statistic.attendance_by_date(**filter_params)
      @charts['attendance_by_subdepartments.bar']  = faculty_statistic.attendance_by('subdepartments', **filter_params)
    end
  end
end
