class EducationDepartment::Filling::PresencesController < AuthController
  include CacheBuster

  inherit_resources
  load_and_authorize_resource

  custom_actions :resource => :change, :collection => [:check_all, :uncheck_all]

  before_filter :find_lesson

  def change
    @presence.last_change_by = current_user.id
    @presence.creator = :education_department
    @presence.change_state
    @presence.save

    render partial: 'education_department/presences/presence',
      locals: { presence: @presence, lesson: @lesson },
      layout: false and return
  end

  def check_all
    @lesson.presences.each { |presence|
      presence.update_attributes(
        state: 'was',
        creator: :education_department,
        last_change_by: current_user.id
      )
    } if @lesson.realized?

    redirect_to education_department_filling_faculty_group_lessons_path(
      @faculty.abbr, @group.number, by_date: @lesson.date_on
    )
  end

  def uncheck_all
    @lesson.presences.each { |presence|
      presence.update_attributes(
        state: 'wasnt',
        creator: :education_department,
        last_change_by: current_user.id
      )
    } if @lesson.realized?

    redirect_to education_department_filling_faculty_group_lessons_path(
      @faculty.abbr, @group.number, by_date: @lesson.date_on
    )
  end

  private

  def find_lesson
    @faculty = Faculty.find_by(abbr: params[:faculty_id])
    @group   = Group.find_by(number: params[:group_id])
    @lesson  = Lesson.find(params[:lesson_id])
  end
end
