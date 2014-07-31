class GroupLeader::GroupsController < AuthController
  def show
    @group = current_user.leaded_groups.first
  end
end
