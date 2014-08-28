class Lecturer::DisciplinesController < AuthController
  include FilterParams
  include DateRange


  def show
    @charts = {}
    @discipline = params[:id]
    @lecturer = current_user.lecturers.first
    @charts['attendance_by_dates.line'] = Statistic::Lecturer.new(@lecturer, nil).attendance_by_date_of_kind('disciplines', @discipline, **filter_params)
    @charts['attendance_by_groups.bar'] = Statistic::Discipline.new("#{@discipline}_#{@lecturer}", "#{current_namespace}/disciplines/#{@discipline}").attendance_by('groups', **filter_params)
  end
end
