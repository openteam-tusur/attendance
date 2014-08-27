class Manage::GroupLeaderPermissionsController < ApplicationController
  inherit_resources

  actions :new, :create, :destroy

  belongs_to :group, :finder => :find_by_number

  defaults :resource_class => Permission, :instance_name => :permission, :collection_name => :permissions

  layout 'manage'

  rescue_from CanCan::AccessDenied do |exception|
    render :file => "#{Rails.root}/public/403", :formats => [:html], :status => 403, :layout => false
  end

  before_filter :authorize_user

  def create
    create! {
      redirect_to manage_faculty_path(@group.faculty) and return
    }
  end

  def destroy
    destroy! {
      redirect_to manage_faculty_path(@group.faculty) and return
    }
  end

  protected

  def authorize_user
    authorize! :manage_group_leader_permissions, Group.find_by_number!(params[:group_id]).faculty
  end

  def build_resource
    super

    @permission.role = :group_leader
    @permission.context_type = 'Group'

    @permission
  end
end