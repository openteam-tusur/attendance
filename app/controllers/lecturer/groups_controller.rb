class Lecturer::GroupsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  defaults :finder => :find_by_number

  before_filter :find_lecturer

  def index
    @charts = {}
    lecturer_statistic = Statistic::Lecturer.new(@lecturer, current_namespace)
    @charts['attendance_by_disciplines.bar'] = lecturer_statistic.attendance_by('disciplines', **filter_params)
  end

  def show
    @charts = {}
    @group = @lecturer.groups.actual.find_by(:number => params[:id])

    @discipline = params[:discipline_id]
    @charts['attendance_by_dates.line']   = Statistic::Discipline.new("#{@group}_#{@lecturer}", nil).attendance_by_date_of_kind('disciplines', @discipline, **filter_params)
    @charts['attendance_by_students.bar'] = Statistic::Discipline.new("#{@group}_#{@discipline}_#{@lecturer}", nil).attendance_by('students', **filter_params)
  end

  private
  def find_lecturer
    @lecturer = current_user.lecturers.first
  end
end
