class EducationDepartment::FacultiesController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  def index
    university_statistic = Statistic::University.new(nil)
    @attendance_by_date = university_statistic.attendance_by_date(**filter_params)
    @attendance_by_course = university_statistic.attendance_by('courses', **filter_params)
    @attendance_by_faculty = university_statistic.attendance_by('faculties', **filter_params)
    @attendance_by_subdepartment = university_statistic.attendance_by('subdepartments', **filter_params)
  end
end
