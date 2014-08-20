class EducationDepartment::FacultiesController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  def index
    @attendance_by_date = Statistic::Whole.new.attendance_by_date(**filter_params)
    @attendance_by_faculties = Statistic::Whole.new.attendance_by_faculties(**filter_params)
  end
end
