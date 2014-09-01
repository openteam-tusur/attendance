class Lecturer::GroupsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  defaults :finder => :find_by_number

  def show
    @charts     = {}
    @lecturer   = current_user.lecturers.first
    @group      = @lecturer.groups.actual.find_by(:number => params[:id])
    @discipline = params[:discipline_id]
    @parent_url = lecturer_discipline_path(@discipline, :filter => params[:filter])
    group_statistic = Statistic::Lecturer.new("#{@lecturer}:#{@discipline}:#{@group}", nil)
    @charts['attendance_by_dates.line']   = group_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_students.bar'] = group_statistic.attendance_by('students', **filter_params)
  end
end
