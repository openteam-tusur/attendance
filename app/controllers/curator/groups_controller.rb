class Curator::GroupsController < AuthController
  actions :index, :show

  def show
    @group = current_user.curated_groups.find(params[:id])
  end

  def index
    @groups = current_user.curated_groups
  end
end
