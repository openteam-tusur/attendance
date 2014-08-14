class EducationDepartment::PermissionsController < AuthController
  actions :index, :new, :create, :destroy

  has_scope :for_context, :default => 1 do |controller, scope|
    case controller.params[:for_role]
    when 'dean'
      scope.for_context('Faculty')
    when 'subdepartment'
      scope.for_context('Subdepartment')
    else
      scope.for_context(['Faculty', 'Subdepartment'])
    end
  end

  has_scope :for_role,    :default => ['dean', 'subdepartment']

  before_filter :build_context, :on => [:new, :create]

  def index
    index!{
      @permissions = Kaminari.paginate_array(@permissions).page(params[:page]).per(10)
    }
  end

  def create
    create!{
      redirect_to education_department_permissions_path(:for_role => params[:for_role]) and return
    }
  end

  def destroy
    destroy!{ render :nothing => true and return }
  end

  private
    def build_context
      case params[:for_role]
        when 'dean'
          @context_ids  = Faculty.order('title')
        when 'subdepartment'
          @context_ids  = Subdepartment.order('title')
      end
    end

    def permission_params
      params.require(:permission).permit(:user_id, :role, :email, :context_id, :context_type)
    end
end
