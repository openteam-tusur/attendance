class Dean::MissesController < AuthController
  actions :all, :except => :show

  has_scope :for_missing, :default => 'Student'

  private

  def miss_params
    params.require(:miss).permit(:missing_id, :starts_at, :ends_at, :note)
  end
end
