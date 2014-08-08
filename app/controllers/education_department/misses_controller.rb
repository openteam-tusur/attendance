class EducationDepartment::MissesController < AuthController
  has_scope :for_missing, :default => 'Lecturer'
  actions :all, :except => :show

  private

  def miss_params
    params.require(:miss).permit(:missing_id, :starts_at, :ends_at, :note)
  end
end