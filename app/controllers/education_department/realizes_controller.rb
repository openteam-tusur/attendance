class EducationDepartment::RealizesController < AuthController
  inherit_resources
  load_and_authorize_resource
  custom_actions resource: [:accept, :refuse, :change]

  before_filter :find_lesson, only: :change_all

  def accept
    accept!{
      change_approved(:reasonable)

      render :partial => 'education_department/realizes/realize' and return
    }
  end

  def refuse
    refuse!{
      change_approved(:unreasonable)

      render :partial => 'education_department/realizes/realize' and return
    }
  end

  def change
    change!{
      change_approved(:unfilled)

      render :partial => 'education_department/realizes/realize' and return
    }
  end

  def change_all
    @lesson.realizes.change_state
    @lesson.presences.update_all(state: nil)

    redirect_to education_department_filling_faculty_group_lessons_path(
      @lesson.faculty.abbr, @lesson.group.number, by_date: @lesson.date_on
    )
  end

  private

  def change_approved(desicion)
    @realize.approved = desicion
    @realize.save
  end

  def find_lesson
    @lesson = Lesson.find(params[:lesson_id])
  end
end
