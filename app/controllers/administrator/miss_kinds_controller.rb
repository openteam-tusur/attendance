class Administrator::MissKindsController < AuthController
  inherit_resources
  load_and_authorize_resource

  actions :all, :except => :show

  private

  def miss_kind_params
    params.require(:miss_kind).permit(:kind)
  end
end
