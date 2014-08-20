class Dean::MissesController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  actions :all, :except => :show

  has_scope :for_missing, :default => 'Student'
  has_scope :ordered, :default => 1, :only => :index

  has_scope :between_dates, :default => 1, :only => :index do |controller, scope|
    scope.between_dates(controller.filter_params[:from], controller.filter_params[:to])
  end

  def index
    index!{
      @misses = Kaminari.paginate_array(@misses).page(params[:page]).per(10)
    }
  end

  private

  def miss_params
    params.require(:miss).permit(:missing_id, :starts_at, :ends_at, :note)
  end
end
