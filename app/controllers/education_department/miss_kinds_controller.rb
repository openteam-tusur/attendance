class EducationDepartment::MissKindsController < AuthController
  inherit_resources
  load_and_authorize_resource

  actions :all, :except => :show

  has_scope :ordered, :default => 1, :only => :index

  private

  def miss_kind_params
    params.require(:miss_kind).permit(:kind)
  end
end
