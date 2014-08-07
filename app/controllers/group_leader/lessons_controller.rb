class GroupLeader::LessonsController < AuthController
  actions :index

  def index
    @group = current_user.leaded_groups.first
    @date  = params[:by_date].try(:to_date) || Date.today
    @lessons = @group.lessons.by_date(@date).order('order_number')
  end
end
