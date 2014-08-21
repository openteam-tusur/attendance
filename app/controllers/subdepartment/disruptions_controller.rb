class Subdepartment::DisruptionsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  actions :index

  def index
    @subdepartment = current_user.subdepartments.first
    @disruptions = @subdepartment.realizes.wasnt.between_dates(*filter_params.values).group_by(&:lecturer)
  end
end
