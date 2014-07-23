class Administrator::SyncsController < AuthController
  inherit_resources
  actions :index

  has_scope :by_created_at, :default => 1 do |controller, scope, _|
    scope.order('created_at DESC')
  end
end