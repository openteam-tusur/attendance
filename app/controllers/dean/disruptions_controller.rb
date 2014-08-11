class Dean::DisruptionsController < AuthController
  actions :index

  def index
    @faculty = current_user.faculties.first
    @disruptions = @faculty.realizes.wasnt.with_lessons.ordered_by_lecturer.group_by(&:lecturer)
  end
end
