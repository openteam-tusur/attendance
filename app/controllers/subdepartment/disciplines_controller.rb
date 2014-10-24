class Subdepartment::DisciplinesController < AuthController
  include FilterParams
  include DateRange

  before_filter :find_lecturer

  def show
    @charts     = {}
    @discipline = params[:id]
    @subdepartment = current_user.subdepartments.first
    @parent_url = subdepartment_lecturer_path(@lecturer.to_s, :filter => params[:filter])
    lecturer_statistic = Statistic::Lecturer.new("#{@lecturer}:#{@subdepartment}:#{@discipline}", "#{current_namespace}/lecturers/#{@lecturer}/disciplines/#{@discipline}")
    @charts['attendance_by_dates.line'] = lecturer_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_groups.bar'] = lecturer_statistic.attendance_by('groups', **filter_params)
  end

  private
  def find_lecturer
    @lecturer = Lecturer.find {|l| l.to_s == params[:lecturer_id]}
  end
end
