class Dean::DisciplinesController < AuthController
  include FilterParams
  include DateRange

  authorize_resource

  before_filter :find_lecturer

  def show
    @charts     = {}
    @discipline = params[:id]
    @faculty = current_user.faculties.first
    @parent_url = dean_lecturer_path(@lecturer.to_s, :filter => params[:filter])
    lecturer_statistic = Statistic::Lecturer.new("#{@lecturer}:#{@faculty}:#{@discipline}", "#{current_namespace}/lecturers/#{@lecturer}/disciplines/#{@discipline}")
    @charts['attendance_by_dates.line'] = lecturer_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_groups.bar'] = lecturer_statistic.attendance_by('groups', **filter_params)
  end

  private
  def find_lecturer
    @lecturer = Lecturer.find {|l| l.to_s == params[:lecturer_id]}
  end
end
