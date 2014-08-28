class EducationDepartment::GroupsController < AuthController
  include FilterParams
  include DateRange

  def show
    @charts = {}
    @group = Group.actual.find_by(:number => params[:id])
    group_statistic = Statistic::Group.new(@group, current_namespace)
    @charts['attendance_by_dates.line']   = group_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_students.bar'] = group_statistic.attendance_by('students', **filter_params)
  end
end
