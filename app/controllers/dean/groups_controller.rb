class Dean::GroupsController < AuthController
  include FilterParams
  include DateRange

  def index
    @faculty = current_user.faculties.first
    @groups  = current_user.faculty_groups
    @attendance_by_date = Statistic::Faculty.new(@faculty).attendance_by_date(**filter_params)
    @attendance_by_groups = Statistic::Faculty.new(@faculty).attendance_by_groups(**filter_params)
  end
end
