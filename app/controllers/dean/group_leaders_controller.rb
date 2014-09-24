class Dean::GroupLeadersController < AuthController
  load_and_authorize_resource

  def index
    @faculty = current_user.faculties.first
    @without_group_leaders = @faculty.groups.select {|g| g.permissions.where(:role => :group_leader).empty?}
    @inactive = @faculty.groups.joins(:permissions).where(:permissions => {:role => :group_leader, :user_id => nil})
    @group_leaders = Kaminari.paginate_array(GroupLeader.new(@faculty).who_unfilled).page(params[:page]).per(10)
  end
end
