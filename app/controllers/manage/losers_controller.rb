class Manage::LosersController < ApplicationController
  layout 'manage'

  rescue_from CanCan::AccessDenied do |exception|
    render :file => "#{Rails.root}/public/403", :formats => [:html], :status => 403, :layout => false
  end

  before_filter :find_faculty
  before_filter :authorize_user

  def group_leaders
   @groups =  Presence
                .where(:kind => 'not_marked')
                .where(:date_on => Presence.last_week_begin..Presence.last_week_end)
                .joins(:lesson)
                .where('lessons.state' => :took_place)
                .joins(:faculty)
                .where('faculties.id' => @faculty.id)
                .where('people.active' => true)
                .map(&:group)
                .uniq
  end

  def students
    @students = @faculty.lose_students
  end

  def lecturers
    @lecturers = Lecturer.joins(:groups).where('groups.faculty_id=?', @faculty.id).joins(:lessons).where("lessons.state='wasnt_took_place' AND lessons.date_on BETWEEN ? AND ?", Presence.last_week_begin, Presence.last_week_end).uniq
  end

  private
    def find_faculty
      @faculty = Faculty.find_by_abbr(params[:faculty_id])
    end

    def authorize_user
      authorize! :read, @faculty
    end
end

