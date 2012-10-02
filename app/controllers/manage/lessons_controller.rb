class Manage::LessonsController < Manage::ApplicationController

  belongs_to :group, :finder => :find_by_number! do
    belongs_to :student, :optional => true
  end

  has_scope :date do |controller, scope, value|
    scope.by_date(value)
  end

  actions :all, :only => :index

  before_filter :set_today

  def switch_state
    @lesson = Lesson.find(params[:lesson_id])
    @lesson.switch_state
    render :partial => 'manage/lessons/lesson_state', :locals => { :lesson => @lesson }, :layout => false and return
  end

  def index
    authorize! :read, association_chain.last.lessons.build
  end

  private
    def set_today
      params[:date] ||= Time.zone.today.to_s
    end
end
