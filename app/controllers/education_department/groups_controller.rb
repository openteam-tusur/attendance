class EducationDepartment::GroupsController < AuthController
  include FilterParams
  include DateRange

  def show
    @charts = {}
    @group = Group.actual.find_by(:number => params[:id])

    @parent_url = education_department_faculties_path(:filter => params[:filter])

    group_statistic = Statistic::Group.new(@group, nil)
    @charts['attendance_by_dates.line']   = group_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_students.bar'] = group_statistic.attendance_by('students', **filter_params)
  end
end
