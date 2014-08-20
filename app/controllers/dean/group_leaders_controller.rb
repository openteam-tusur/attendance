class Dean::GroupLeadersController < AuthController
  inherit_resources
  load_and_authorize_resource

  def index
    @faculty = current_user.faculties.first
    @group_leaders = GroupLeader.new(@faculty).who_unfilled
  end
end
