class Dean::LecturersController < AuthController
  include FilterParams
  include DateRange

  def index
    @charts = {}
    @faculty = current_user.faculties.first
    faculty_statistic = Statistic::Faculty.new(@faculty, current_namespace)

    @charts['attendance_by_lecturers.bar']  = faculty_statistic.attendance_by('lecturers', **filter_params)
  end

  def show
    @charts = {}
    @faculty = current_user.faculties.first
    @lecturer = Lecturer.find {|l| l.to_s == params[:id]}
    @parent_url = dean_lecturers_path(:filter => params[:filter])

    lecturer_statistic = Statistic::Lecturer.new("#{@lecturer}:#{@faculty}", "#{current_namespace}/lecturers/#{@lecturer}")
    @charts['attendance_by_disciplines.bar'] = lecturer_statistic.attendance_by('disciplines', **filter_params)
  end
end
