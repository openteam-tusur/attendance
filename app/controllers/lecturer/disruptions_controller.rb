class Lecturer::DisruptionsController < AuthController
  def index
    @lecturer = current_user.lecturers.first
    @disruptions = @lecturer.realizes.wasnt.with_lessons.ordered_by_lesson
  end
end
