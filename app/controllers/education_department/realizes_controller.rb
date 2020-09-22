class EducationDepartment::RealizesController < AuthController
  inherit_resources
  load_and_authorize_resource

  before_filter :find_lesson

  def change
    @lesson.realizes.change_state
    @lesson.presences.update_all(state: nil)
    redirect_to education_department_filling_faculty_group_lessons_path(
      @lesson.faculty.abbr, @lesson.group.number, by_date: @lesson.date_on
    )
  end

  private

  def find_lesson
    @lesson = Lesson.find(params[:lesson_id])
  end
end
