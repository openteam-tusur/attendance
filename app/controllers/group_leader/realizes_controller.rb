class GroupLeader::RealizesController < AuthController
  include CacheBuster

  custom_actions :collection => :change

  before_filter :find_lesson

  def change
    @lesson.realizes.change_state
    redirect_to group_leader_lessons_url(:by_date => @lesson.date_on)
  end

  private

  def find_lesson
    @lesson = Lesson.find(params[:lesson_id])
  end
end

