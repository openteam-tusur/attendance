class Dean::GroupLeadersController < AuthController
  def index
    @faculty = current_user.faculties.first
    @group_leaders = GroupLeader.new(@faculty).who_unfilled
  end
end
