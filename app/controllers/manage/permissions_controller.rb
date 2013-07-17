class Manage::PermissionsController < Manage::ApplicationController
  inherit_resources

  actions :all

  def index
    index! {
      @group_leader_permissions = Permission.group_leaders
      @faculty_worker_permissions = Permission.faculty_workers
    }
  end
end
