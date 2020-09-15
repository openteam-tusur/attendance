class EducationDepartment::Filling::FacultiesController < AuthController

  def index
    @faculties = Faculty.actual.without_untracked
  end

end
