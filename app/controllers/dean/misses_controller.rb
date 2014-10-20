class Dean::MissesController < AuthController
  include FilterParams
  include DateRange

  before_filter :find_faculty, :only => :index

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
      @misses = Kaminari.paginate_array(@misses).page(params[:page])
    }
  end

  private

  def begin_of_association_chain
    @faculty
  end

  def find_faculty
    @faculty = current_user.faculties.first
  end

  def miss_params
    params.require(:miss).permit(:missing_id, :starts_at, :ends_at, :note, :miss_kind_id)
  end
end
