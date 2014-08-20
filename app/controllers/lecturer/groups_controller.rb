class Lecturer::GroupsController < AuthController
  inherit_resources
  load_and_authorize_resource

  def index
    @lecturer = current_user.lecturers.first
    @groups   = @lecturer.groups
  end
end
