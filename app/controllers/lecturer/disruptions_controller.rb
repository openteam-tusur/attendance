class Lecturer::DisruptionsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  def index
    @lecturer = current_user.lecturers.first
    @disruptions = Kaminari.paginate_array(@lecturer.realizes.wasnt.between_dates(*filter_params.values)).page(params[:page])
  end
end
