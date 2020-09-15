class EducationDepartment::Filling::FacultiesController < AuthController

  def index
    @faculties = Faculty.actual.without_untracked
  end

  def show
    @faculty = Faculty.includes(:groups).find_by(abbr: params[:id])
    @groups = @faculty.groups.actual.order(:course, :number).group_by(&:course)
  end

end
