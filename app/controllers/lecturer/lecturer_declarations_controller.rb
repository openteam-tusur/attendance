class Lecturer::LecturerDeclarationsController < AuthController
  inherit_resources
  load_and_authorize_resource

  has_scope :for_declarator, :default => 'Person'
  actions :all, :except => [:index, :show]

  before_filter :find_realize, :only => [:new, :edit]

  def create
    create!{
      redirect_to lecturer_disruptions_path and return
    }
  end

  def update
    update!{ redirect_to lecturer_disruptions_path and return }
  end

  def destroy
    destroy!{ redirect_to lecturer_disruptions_path and return }
  end

  private

  def build_resource
    @lecturer_declarations ||= current_user.lecturers.first.lecturer_declarations.new(:realize_id => params[:realize_id], :reason => permitted_params[:lecturer_declaration][:reason] || nil)
  end

  def find_realize
    @realize = Realize.find(params[:realize_id])
  end

  def permitted_params
    { :lecturer_declaration => params.fetch(:lecturer_declaration, {}).permit(:reason) }
  end
end
