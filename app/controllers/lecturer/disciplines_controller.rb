class Lecturer::DisciplinesController < AuthController
  include FilterParams
  include DateRange

  before_filter :find_lecturer

  def index
    @charts = {}
    lecturer_statistic = Statistic::Lecturer.new(@lecturer, current_namespace)
    @charts['attendance_by_disciplines.bar'] = lecturer_statistic.attendance_by('disciplines', **filter_params)
  end

  def show
    @charts     = {}
    @discipline = params[:id]
    @parent_url = lecturer_root_path(:filter => params[:filter])
    lecturer_statistic = Statistic::Lecturer.new("#{@lecturer}:#{@discipline}", "#{current_namespace}/disciplines/#{@discipline}")
    @charts['attendance_by_dates.line'] = lecturer_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_groups.bar'] = lecturer_statistic.attendance_by('groups', **filter_params)
  end

  private
  def find_lecturer
    @lecturer = current_user.lecturers.first
  end
end
