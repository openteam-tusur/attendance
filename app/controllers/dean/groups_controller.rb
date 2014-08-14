class Dean::GroupsController < AuthController
  def index
    @faculty = current_user.faculties.first
    @groups  = current_user.faculty_groups
  end
end
