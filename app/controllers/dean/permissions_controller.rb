class Dean::PermissionsController < AuthController
  actions :index, :new, :create, :destroy

  has_scope :for_context, :default => 'Group'
  has_scope :for_role
end
