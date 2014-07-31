class GroupLeader::LessonsController < AuthController
  def index
    @group = current_user.leaded_groups.first
    @lessons = @group.lessons.by_date(params[:by_date] || Date.today)
  end
end
