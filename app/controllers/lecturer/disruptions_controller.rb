class Lecturer::DisruptionsController < AuthController
  def index
    @lecturer = current_user.lecturers.first
    @disruptions = Kaminari.paginate_array(@lecturer.realizes.wasnt.with_lessons.ordered_by_lesson).page(params[:page]).per(10)
  end
end
