class Lecturer::GroupsController < AuthController
  def index
    @lecturer = current_user.lecturers.first
    @groups   = @lecturer.groups
  end
end
