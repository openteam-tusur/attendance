class Subdepartment::CoursesController < AuthController
  include FilterParams
  include DateRange

  def show
    @subdepartment = current_user.subdepartments.first
    @course = params[:id]

    course_groups = @subdepartment.groups.actual.by_course(@course).pluck(:number)

    subdepartment_statistic = Statistic::Subdepartment.new(@subdepartment)
    @attendance_by_date = subdepartment_statistic.attendance_by_date_of_kind('courses', @course, **filter_params)
    @attendance_by_group = subdepartment_statistic.attendance_by('groups', **filter_params).select{ |k,v| course_groups.include?(k) }
  end
end
