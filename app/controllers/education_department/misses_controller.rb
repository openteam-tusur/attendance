class EducationDepartment::MissesController < AuthController
  has_scope :for_missing, :default => 'Lecturer'
  actions :all, :except => :show

  def index
    index!{ @misses = Kaminari.paginate_array(@misses).page(params[:page]).per(10) }
  end

  private

  def miss_params
    params.require(:miss).permit(:missing_id, :starts_at, :ends_at, :note)
  end
end
