class EducationDepartment::PermissionsController < AuthController
  actions :index, :new, :create, :destroy

  has_scope :for_context, :default => 'Faculty'
  has_scope :for_role,    :default => 'dean'

  before_filter :build_context, :on => [:new, :create]

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
