class Dean::GroupLeadersController < AuthController
  include FilterParams
  include DateRange

  load_and_authorize_resource

  def index
    @faculty = current_user.faculties.first
    @without_group_leaders = @faculty.groups.actual.select {|g| g.permissions.where(:role => :group_leader).empty?}
    @inactive = @faculty.groups.joins(:permissions).where(:permissions => {:role => :group_leader, :user_id => nil})
    @group_leaders = GroupLeader.new(@faculty).who_unfilled(filter_params)
  end
end
