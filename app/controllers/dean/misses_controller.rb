class Dean::MissesController < AuthController
  has_scope :for_student, :default => 1
  actions :all, :except => [:show, :edit]

  private

  def miss_params
    params.require(:miss).permit(:missing_id, :starts_at, :ends_at, :note)
  end
end
