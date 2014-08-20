class Lecturer::GroupsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  def index
    @lecturer = current_user.lecturers.first
    @groups   = @lecturer.groups
    lecturer_statistic = Statistic::Lecturer.new(@lecturer)
    @attendance_by_group = lecturer_statistic.attendance_by('by_group', **filter_params)
    @attendance_by_discipline = lecturer_statistic.attendance_by('by_discipline', **filter_params)
  end
end
