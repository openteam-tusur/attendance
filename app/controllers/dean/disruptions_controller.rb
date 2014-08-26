class Dean::DisruptionsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  actions :index

  def index
    @faculty = current_user.faculties.first
    @disruptions = @faculty.realizes.wasnt.between_dates(*filter_params.values).with_lessons.ordered_by_lecturer.group_by(&:lecturer)
  end
end
