class Lecturer::GroupsController < AuthController
  def index
    @disciplines = current_user.teached_disciplines
    @groups = @disciplines.map(&:groups).flatten
  end
end
