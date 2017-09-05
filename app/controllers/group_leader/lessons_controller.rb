class GroupLeader::LessonsController < AuthController
  include DateRange

  inherit_resources
  load_and_authorize_resource

  actions :index

  def index
    @group = current_user.leaded_groups.actual.first
    @date  = params[:by_date].try(:to_date) || today
    @calendar_months = (semester_begin..semester_end).group_by(&:month)
    lessons = @group.lessons.actual.by_date(@date).order('order_number').includes(:realizes, :discipline) rescue []
    @lessons_grouped_by_order = lessons.group_by(&:order_number)
    @lessons_groupped_by_day = @group.lessons.actual.includes(:realizes, :presences).group_by(&:date_on) rescue []
  end
end
