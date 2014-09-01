class Dean::GroupLeadersController < AuthController
  inherit_resources
  load_and_authorize_resource

  def index
    @faculty = current_user.faculties.first
    @group_leaders = Kaminari.paginate_array(GroupLeader.new(@faculty).who_unfilled).page(params[:page]).per(10)
  end
end
