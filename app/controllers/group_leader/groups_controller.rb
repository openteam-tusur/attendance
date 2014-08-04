class GroupLeader::GroupsController < AuthController
  actions :show

  def show
    @group = current_user.leaded_groups.first
  end
end
