class Administrator::PermissionsController < AuthController
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
          @context_type = 'Lecturer'
          @context_ids  = Lecturer.order('surname')
        when 'subdepartment'
          @context_type = 'Subdepartment'
          @context_ids  = Subdepartment.order('title')
      end
    end

    def permission_params
      params.require(:permission).permit(:user_id, :role, :email, :context_id, :context_type)
    end
end
