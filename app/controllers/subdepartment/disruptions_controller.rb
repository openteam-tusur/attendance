class Subdepartment::DisruptionsController < AuthController
  inherit_resources
  load_and_authorize_resource

  actions :index

  def index
    @subdepartment = current_user.subdepartments.first
    @disruptions = @subdepartment.realizes.wasnt.with_lessons.ordered_by_lecturer.group_by(&:lecturer)
  end
end
