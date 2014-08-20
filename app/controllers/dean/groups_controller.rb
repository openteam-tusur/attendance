class Dean::GroupsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  def index
    @faculty = current_user.faculties.first
    @groups  = current_user.faculty_groups
    faculty_statistic = Statistic::Faculty.new(@faculty)
    @attendance_by_date = faculty_statistic.attendance_by_date(**filter_params)
    @attendance_by_group = faculty_statistic.attendance_by('by_group', **filter_params)
    @attendance_by_course = faculty_statistic.attendance_by('by_course', **filter_params)
  end
end
