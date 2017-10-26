class Subdepartment::PermissionsController < AuthController
  inherit_resources
  # load_and_authorize_resource

  actions :new, :create, :destroy

  has_scope :for_context, default: 1 do |controller, scope|
    case controller.params[:for_role]
    when'curator'
      scope.for_context('Group')
    else
      scope.for_context(['Group', 'Subdepartment'])
    end
  end

  has_scope :for_role, default: [ 'curator']

  before_filter :build_context, on: [:new, :create, :index]

  def index
    search = Permission.search do
      keywords params[:q] if params[:q]

      with :context_type, 'Group'
      with :context_ids, current_user.subdepartments.first.groups.pluck(:id)
      with :role, 'curator'

      order_by :user_fullname, :asc

      paginate page: params[:page], per_page: 20
    end
    @permissions = search.results
  end

  def create
    create! do |success, failure|
      success.html { redirect_to subdepartment_permissions_path(for_role: @permission.role) and return }
      failure.html { render action: :new and return }
    end
  end

  def destroy
    destroy!{ render nothing: true and return }
  end

  private
    def build_context
      @subdepartment  = current_user.subdepartments.first
      @context_type = 'Group'
      @context_ids  = @subdepartment.groups.order('number')
    end

    def permission_params
      params.require(:permission).permit(:user_id, :role, :email, :context_id, :context_type)
    end
end
