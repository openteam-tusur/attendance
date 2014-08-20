class Administrator::SyncsController < AuthController
  inherit_resources
  load_and_authorize_resource

  actions :index

  def index
    index!{ @syncs = Kaminari.paginate_array(@syncs).page(params[:page]).per(10) }
  end

  has_scope :by_created_at, :default => 1 do |controller, scope, _|
    scope.order('created_at DESC')
  end
end
