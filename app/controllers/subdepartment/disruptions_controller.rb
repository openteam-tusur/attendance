class Subdepartment::DisruptionsController < AuthController
  actions :index

  def index
    @subdepartment = current_user.subdepartments.first
    @disruptions = @subdepartment.realizes.wasnt.with_lessons.ordered_by_lecturer.group_by(&:lecturer)
  end
end
