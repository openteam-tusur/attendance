class Subdepartment::CoursesController < AuthController
  include FilterParams
  include DateRange

  def show
    @charts = {}
    @subdepartment = current_user.subdepartments.actual.first
    @course = params[:id]

    subdepartment_statistic = Statistic::Subdepartment.new("#{@subdepartment}:#{@course}", "#{current_namespace}/courses/#{@course}")

    @parent_url = subdepartment_groups_path(:filter => params[:filter])

    @charts['attendance_by_dates.line'] = subdepartment_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_groups.bar'] = subdepartment_statistic.attendance_by('groups', **filter_params)
  end
end
