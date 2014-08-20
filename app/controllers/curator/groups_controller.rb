class Curator::GroupsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  actions :index, :show

  def show
    @group = current_user.curated_groups.find(params[:id])
    @attendance_by_date = Statistic::Group.new(@group).attendance_by_date(**filter_params)
    @attendance_by_students = Statistic::Group.new(@group).attendance_by_students(**filter_params)
  end

  def index
    @groups = current_user.curated_groups
  end
end
