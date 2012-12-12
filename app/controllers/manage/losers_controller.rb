class Manage::LosersController < ApplicationController
  layout 'manage'

  rescue_from CanCan::AccessDenied do |exception|
    render :file => "#{Rails.root}/public/403", :formats => [:html], :status => 403, :layout => false
  end

  before_filter :find_faculty
  before_filter :authorize_user

  def group_leaders
    @groups = Group.joins(:presences).where("presences.kind = 'not_marked' AND groups.faculty_id = ? AND presences.date_on BETWEEN ? AND ?", @faculty.id, Presence.last_week_begin, Presence.last_week_end).uniq
  end

  def students
    @students = @faculty.lose_students
  end

  def lecturers
    @lessons = Lesson.joins(:group).where("lessons.state = 'wasnt_took_place' AND groups.faculty_id = ? AND lessons.date_on BETWEEN ? AND ?", @faculty.id, Presence.last_week_begin, Presence.last_week_end).uniq
  end

  private
    def find_faculty
      @faculty = Faculty.find_by_abbr(params[:faculty_id])
    end

    def authorize_user
      authorize! :manage, @faculty
    end
end

