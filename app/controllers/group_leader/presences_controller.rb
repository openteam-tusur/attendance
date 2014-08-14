class GroupLeader::PresencesController < AuthController
  include CacheBuster

  custom_actions :resource => :change, :collection => [:check_all, :uncheck_all]

  before_filter :find_lesson

  def change
    @presence.change_state
    @presence.save

    render :partial => 'group_leader/presences/presence', :locals => { :presence => @presence, :lesson => @lesson }, :layout => false and return
  end

  def check_all
    @lesson.presences.update_all(:state => 'was')
    redirect_to group_leader_lessons_url(:by_date => @lesson.date_on)
  end

  def uncheck_all
    @lesson.presences.update_all(:state => 'wasnt')
    redirect_to group_leader_lessons_url(:by_date => @lesson.date_on)
  end

  private

  def find_lesson
    @group  = current_user.group
    @lesson = Lesson.find(params[:lesson_id])
  end
end
