class Subdepartment::GroupsController < AuthController
  def index
    @subdepartment = current_user.subdepartments.first
    @groups        = @subdepartment.groups
  end

  def show
    @subdepartment = current_user.subdepartments.first
    @group = @subdepartment.groups.find(params[:id])
  end
end
