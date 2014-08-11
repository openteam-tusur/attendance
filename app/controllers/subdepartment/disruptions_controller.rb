class Subdepartment::DisruptionsController < AuthController
  actions :index

  def index
    @subdepartment = current_user.subdepartments.first
    @disruptions = @subdepartment.realizes.wasnt.with_lessons.ordered.group_by(&:lecturer)
  end
end
