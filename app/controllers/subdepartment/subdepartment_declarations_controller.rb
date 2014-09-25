class Subdepartment::SubdepartmentDeclarationsController < AuthController
  inherit_resources
  load_and_authorize_resource

  has_scope :for_declarator, :default => 'Subdepartment'
  actions :all, :except => [:index, :show]

  before_filter :find_realize, :only => [:new, :edit]

  layout false
  respond_to :js, :only => [:new, :create, :update]

  def create
    create!{
      redirect_to subdepartment_disruptions_path and return
    }
  end

  def update
    update!{
      redirect_to subdepartment_disruptions_path and return
    }
  end

  def destroy
    destroy!{
      render :partial => 'subdepartment/disruptions/lesson', :locals => { :realize => @subdepartment_declaration.realize } and return
    }
  end

  private

  def build_resource
    @subdepartment_declarations ||= current_user.subdepartments.first.subdepartment_declarations.new(:realize_id => params[:realize_id], :reason => permitted_params[:subdepartment_declaration][:reason] || nil)
  end

  def find_realize
    @realize = Realize.find(params[:realize_id])
  end

  def permitted_params
    { :subdepartment_declaration => params.fetch(:subdepartment_declaration, {}).permit(:reason) }
  end
end
