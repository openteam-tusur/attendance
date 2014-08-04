class GroupLeader::LessonsController < AuthController
  actions :index

  def index
    @group = current_user.leaded_groups.first
    @lessons = @group.lessons.by_date(params[:by_date] || Date.today).order('order_number')
  end
end
