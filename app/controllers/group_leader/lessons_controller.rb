class GroupLeader::LessonsController < AuthController
  actions :index

  def index
    @group = current_user.leaded_groups.first
    @date  = params[:by_date].try(:to_date) || Date.today
    @lessons = @group.lessons.actual.by_date(@date).order('order_number').includes(:realizes, :discipline)
    @lessons_groupped_by_day = @group.lessons.actual.includes(:realizes, :presences).group_by(&:date_on)
  end
end
