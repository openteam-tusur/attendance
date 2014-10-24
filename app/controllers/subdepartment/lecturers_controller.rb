class Subdepartment::LecturersController < AuthController
  include FilterParams
  include DateRange

  def index
    @charts = {}
    @subdepartment = current_user.subdepartments.first
    subdepartment_statistic = Statistic::Subdepartment.new(@subdepartment, current_namespace)

    @charts['attendance_by_lecturers.bar']  = subdepartment_statistic.attendance_by('lecturers', **filter_params)
  end

  def show
    @charts = {}
    @subdepartment = current_user.subdepartments.first
    @lecturer = Lecturer.find {|l| l.to_s == params[:id]}
    @parent_url = subdepartment_lecturers_path(:filter => params[:filter])

    lecturer_statistic = Statistic::Lecturer.new("#{@lecturer}:#{@subdepartment}", "#{current_namespace}/lecturers/#{@lecturer}")
    @charts['attendance_by_disciplines.bar'] = lecturer_statistic.attendance_by('disciplines', **filter_params)
  end
end
