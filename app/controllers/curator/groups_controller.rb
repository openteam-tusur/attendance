class Curator::GroupsController < AuthController
  include FilterParams
  include DateRange

  before_filter :set_filter_dates, :only => :index

  inherit_resources
  defaults :finder => :find_by_number
  load_and_authorize_resource

  actions :index, :show

  def index
    @groups = current_user.curated_groups
  end

  def show
    @charts = {}
    @group = current_user.curated_groups.actual.find_by(:number => params[:id])
    group_statistic = Statistic::Group.new(@group, "#{current_namespace}/groups/#{@group}")

    @parent_url = curator_groups_path(:filter => params[:fiter])

    @charts['attendance_by_dates.line']   = group_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_students.bar'] = group_statistic.attendance_by('students', **filter_params)
  end

  private

  def set_filter_dates
    @filter = filter_params
  end
end
