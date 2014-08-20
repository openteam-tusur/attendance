class Lecturer::DisruptionsController < AuthController
  inherit_resources
  load_and_authorize_resource

  def index
    @lecturer = current_user.lecturers.first
    @disruptions = Kaminari.paginate_array(@lecturer.realizes.wasnt.with_lessons.ordered_by_lesson).page(params[:page]).per(10)
  end
end
