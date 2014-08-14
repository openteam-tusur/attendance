class Dean::PermissionsController < AuthController
  actions :index, :new, :create, :destroy

  has_scope :for_context, :default => 'Group'
  has_scope :for_role,    :default => ['group_leader', 'curator']

  before_filter :build_context, :on => [:new, :create]

  def index
    index!{
      @permissions = Kaminari.paginate_array(@permissions).page(params[:page]).per(10)
    }
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
