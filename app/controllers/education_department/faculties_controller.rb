class EducationDepartment::FacultiesController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  def index
    university_statistic = Statistic::University.new(nil)
    @attendance_by_date = university_statistic.attendance_by_date(**filter_params)
    @attendance_by_course = university_statistic.attendance_by('by_course', **filter_params)
    @attendance_by_faculty = university_statistic.attendance_by('by_faculty', **filter_params)
    @attendance_by_subdepartment = university_statistic.attendance_by('by_subdepartment', **filter_params)
  end
end
