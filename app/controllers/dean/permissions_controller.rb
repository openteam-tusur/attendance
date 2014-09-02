class Dean::PermissionsController < AuthController
  inherit_resources
  load_and_authorize_resource

  actions :index, :new, :create, :destroy

  has_scope :for_context, :default => 1 do |controller, scope|
    case controller.params[:for_role]
    when 'group_leader'
      scope.for_context('Group')
    when'curator'
      scope.for_context('Group')
    when 'subdepartment'
      scope.for_context('Subdepartment')
    else
      scope.for_context(['Group', 'Subdepartment'])
    end

  end

  has_scope :for_role,    :default => ['group_leader', 'curator', 'subdepartment']

  before_filter :build_context, :on => [:new, :create, :index]

  def index
    index!{
      @permissions = Kaminari.paginate_array(@permissions.where(:context_id => @context_ids.map(&:id), :context_type => @context_type)).page(params[:page])
    }
  end

  def create
    create! do |success, failure|
      success.html { redirect_to dean_permissions_path(:for_role => @permission.role) and return }
      failure.html { render :action => :new and return }
    end
  end

  def destroy
    destroy!{ render :nothing => true and return }
  end

  private
    def build_context
      @faculty      = current_user.faculties.first
      case params[:for_role]
      when 'group_leader'
        @context_type = 'Group'
        @context_ids  = @faculty.groups.order('number')
      when'curator'
        @context_type = 'Group'
        @context_ids  = @faculty.groups.order('number')
      else 'subdepartment'
        @context_type = 'Subdepartment'
        @context_ids  = @faculty.subdepartments.order('title')
      end
    end

    def permission_params
      params.require(:permission).permit(:user_id, :role, :email, :context_id, :context_type)
    end
end
