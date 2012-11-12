class Manage::LessonsController < Manage::ApplicationController
  belongs_to :group, :finder => :find_by_number! do
    belongs_to :student, :optional => true
  end

  has_scope :date do |controller, scope, value|
    scope.by_date(value)
  end

  actions :index

  respond_to :html, :json

  before_filter :set_today, :only => :index

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
      params[:date] ||= @group.lessons.maximum(:date_on).to_s
    end
end
