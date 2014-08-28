class Curator::GroupsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  actions :index, :show

  def index
    @groups = current_user.curated_groups
  end

  def show
    @charts = {}
    @group = current_user.curated_groups.actual.find(params[:id])
    group_statistic = Statistic::Group.new(@group, nil)

    @charts['attendance_by_dates.line']   = group_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_students.bar'] = group_statistic.attendance_by('students', **filter_params)
  end
end
