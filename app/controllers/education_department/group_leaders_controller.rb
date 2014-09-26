class EducationDepartment::GroupLeadersController < AuthController
  def index
    @faculties = Faculty.actual
  end
end
