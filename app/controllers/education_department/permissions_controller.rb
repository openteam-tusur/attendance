class EducationDepartment::PermissionsController < AuthController
  inherit_resources
  load_and_authorize_resource

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

      @permissions = if params[:q]
                       Permission.search {
                         keywords params[:q]

                         any_of do
                           all_of do
                             with :context_type, 'Faculty'
                             with :context_ids, Faculty.pluck(:id)
                           end

                           all_of do
                             with :context_type, 'Subdepartment'
                             with :context_ids, Subdepartment.pluck(:id)
                           end
                         end

                         order_by :user_fullname, :asc

                         paginate :page => params[:page], :per_page => 20
                       }.results
                     else
                       Kaminari.paginate_array(@permissions.sort_by(&:to_s)).page(params[:page])
                     end
    }
  end

  def create
    create! do |success, failure|
      success.html { redirect_to education_department_permissions_path(:for_role => @permission.role) and return }
      failure.html { render :action => :new and return }
    end
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
