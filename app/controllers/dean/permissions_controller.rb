class Dean::PermissionsController < AuthController
  inherit_resources
  load_and_authorize_resource

  actions :index, :new, :create, :destroy

  has_scope :for_context, :default => 'Group'
  has_scope :for_role,    :default => ['group_leader', 'curator']

  before_filter :build_context, :on => [:new, :create]

  def index
    index!{
      groups_ids = current_user.faculty_groups.map(&:id)
      @permissions = Kaminari.paginate_array(@permissions.where(:context_id => groups_ids)).page(params[:page])
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
      @context_type = 'Group'
      @context_ids  = @faculty.groups.order('number')
    end

    def permission_params
      params.require(:permission).permit(:user_id, :role, :email, :context_id, :context_type)
    end
end
