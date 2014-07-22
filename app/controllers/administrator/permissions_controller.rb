class Administrator::PermissionsController < AuthController
  inherit_resources
  actions :index, :new, :create

  has_scope :for_role

  before_filter :build_context, :on => [:new, :create]

  private
    def build_context
      case params[:for_role]
        when 'administrator'
          @context_type = nil
          @context_ids  = nil
        when 'curator'
          @context_type = 'Group'
          @context_ids  = Group.all
        when 'dean'
          @context_type = 'Faculty'
          @context_ids  = Faculty.all
        when 'education_department'
          @context_type = nil
          @context_ids  = nil
        when 'group_leader'
          @context_type = 'Group'
          @context_ids  = Group.all
        when 'lecturer'
          @context_type = 'Discipline'
          @context_ids  = Discipline.all
        when 'subdepartment'
          @context_type = 'Subdepartment'
          @context_ids  = Subdepartment.all
      end
    end

    def permission_params
      params.require(:permission).permit(:user_id, :role, :email)
    end
end
