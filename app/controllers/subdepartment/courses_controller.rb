class Subdepartment::CoursesController < AuthController
  include FilterParams
  include DateRange

  def show
    @charts = {}
    @subdepartment = current_user.subdepartments.actual.first
    @course = params[:id]

    course_groups = @subdepartment.groups.actual.by_course(@course).pluck(:number)
    subdepartment_statistic = Statistic::Subdepartment.new(@subdepartment, current_namespace)

    @parent_url = subdepartment_groups_path(:filter => params[:filter])

    @charts['attendance_by_dates.line'] = subdepartment_statistic.attendance_by_date_of_kind('courses', @course, **filter_params)
    @charts['attendance_by_groups.bar'] = subdepartment_statistic.attendance_by('groups', **filter_params).select{ |k,v| course_groups.include?(k) }
  end
end
