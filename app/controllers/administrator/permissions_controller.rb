class Administrator::PermissionsController < AuthController
  inherit_resources
  load_and_authorize_resource

  actions :index, :new, :create, :destroy

  has_scope :for_role, :default => 'administrator'

  before_filter :build_context, :on => [:new, :create]

  def index
    index!{
      @permissions = if params[:q]
                       Permission.search {
                         keywords params[:q]

                         order_by :user_fullname, :asc
                       }.results
                     else
                       Kaminari.paginate_array(@permissions.sort_by(&:to_s)).page(params[:page])
                     end
    }
  end

  def create
    create! do |success, failure|
      success.html { redirect_to administrator_permissions_path(:for_role => @permission.role) and return }
      failure.html { render :action => :new and return }
    end
  end

  def destroy
    destroy!{ render :nothing => true and return }
  end

  private
    def build_context
      case params[:for_role]
        when 'administrator'
          @context_type = nil
          @context_ids  = nil
        when 'curator'
          @context_type = 'Group'
          @context_ids  = Group.order('number')
        when 'dean'
          @context_type = 'Faculty'
          @context_ids  = Faculty.order('title')
        when 'education_department'
          @context_type = nil
          @context_ids  = nil
        when 'group_leader'
          @context_type = 'Group'
          @context_ids  = Group.order('number')
        when 'lecturer'
          @context_type = 'Person'
          @context_ids  = Lecturer.order('surname')
        when 'subdepartment'
          @context_type = 'Subdepartment'
          @context_ids  = Subdepartment.order('title')
      end
    end

    def permission_params
      params.require(:permission).
        permit(
          :user_id,
          :name,
          :role,
          :email,
          :context_id,
          :context_type
      )
    end
end
