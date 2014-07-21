class Administrator::PermissionsController < AuthController
  inherit_resources
  actions :index, :new, :create

  has_scope :for_role

  private
    def permission_params
      params.require(:permission).permit(:user_id, :role)
    end
end
