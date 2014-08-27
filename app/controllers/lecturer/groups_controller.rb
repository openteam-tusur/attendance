class Lecturer::GroupsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  defaults :finder => :find_by_number

  before_filter :find_lecturer

  def index
    @groups   = @lecturer.groups
    lecturer_statistic = Statistic::Lecturer.new(@lecturer)
    @attendance_by_group = lecturer_statistic.attendance_by('groups', **filter_params)
    @attendance_by_discipline = lecturer_statistic.attendance_by('disciplines', **filter_params)
  end

  def show
    @attendance_by_student = Statistic::Lecturer.new(@lecturer).attendance_by('students', **filter_params)
  end

  def find_lecturer
    @lecturer = current_user.lecturers.first
  end
end
