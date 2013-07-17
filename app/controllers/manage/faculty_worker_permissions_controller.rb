class Manage::FacultyWorkerPermissionsController < ApplicationController
  inherit_resources

  actions :index, :new, :create, :destroy

  belongs_to :faculty, :finder => :find_by_abbr

  defaults :resource_class => Permission, :instance_name => :permission, :collection_name => :permissions

  layout 'manage'

  rescue_from CanCan::AccessDenied do |exception|
    render :file => "#{Rails.root}/public/403", :formats => [:html], :status => 403, :layout => false
  end

  def index
    @faculties = Faculty.reorder('abbr ASC')
  end

  def create
    create! {
      redirect_to manage_faculty_worker_permissions_path and return
    }
  end

  def destroy
    destroy! {
      redirect_to manage_faculty_worker_permissions_path and return
    }
  end

  protected

  def build_resource
    super

    @permission.role = :faculty_worker
    @permission.context_type = 'Faculty'

    @permission
  end
end
