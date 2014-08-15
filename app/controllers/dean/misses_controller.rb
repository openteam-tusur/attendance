class Dean::MissesController < AuthController
  actions :all, :except => :show

  has_scope :for_missing, :default => 'Student'
  has_scope :ordered, :default => 1, :only => :index

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
