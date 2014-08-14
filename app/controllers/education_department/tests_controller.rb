class EducationDepartment::PermissionsController < AuthController
  skip_load_and_authorize_resource
  actions :index, :new, :create, :destroy

  before_filter :build_context, :on => [:new, :create]

  def index
    @permissions = Permission.where(:role => [:dean, :subdepartment])
  end

  def new
    @permission = Permission.new(:context_type => @context_type, :role => params[:for_role])

    authorize! :manage, @permission
  end

  def create
    @permission = Permission.create(permission_params.merge(:context_type => @context_type, :role => params[:for_role]))
    authorize! :manage, @permission

    redirect_to education_department_permissions_path and return
  end

  def destroy
    destroy!{ render :nothing => true and return }
  end

  private

  def build_context
    case params[:for_role]
      when 'dean'
        @context_type = 'Faculty'
        @context_ids  = Faculty.order('title')
      when 'subdepartment'
        @context_type = 'Subdepartment'
        @context_ids  = Subdepartment.order('title')
    end
  end

  def permission_params
    params.require(:permission).permit(:user_id, :role, :email, :context_id, :context_type)
  end
end
