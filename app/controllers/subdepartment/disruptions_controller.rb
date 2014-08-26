class Subdepartment::DisruptionsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  actions :index

  def index
    @subdepartment = current_user.subdepartments.first
    @disruptions = Sunspot.search Realize do |s|
      s.with(:lecturer).starting_with(params[:name]) if params[:name].present?
      s.with(:lesson_date).between(filter_params[:from]..filter_params[:to])
      s.with :approved, params[:approved] == 1 ? true : false unless params[:approved].nil?
      s.with(:subdepartment_id, @subdepartment.id)
      s.with :state, :wasnt

      s.order_by(:lesson_date, :desc)
      s.group(:lecturer) { limit 10000 }

      s.paginate :page => params[:page], :per_page => 10
    end.group(:lecturer).groups
  end
end
