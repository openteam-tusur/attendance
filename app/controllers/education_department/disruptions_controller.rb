require 'grouped_realizes'
class EducationDepartment::DisruptionsController < AuthController
  include DisruptionFilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  before_filter :set_params, :only => :index

  def index
    @filter_params = filter_params

    @faculties = Faculty.all

    @disruptions = Realize.search do |s|
      s.with(:lecturer).starting_with(@name) if @name.present?
      s.with(:lesson_date).between(filter_params[:from]..filter_params[:to])
      s.with :faculty, @faculty if @faculty.present?
      s.with :approved, @approved if @approved.present?
      s.with :state, :wasnt

      s.order_by(:lesson_date)
      s.group :faculty do
        limit 10000
      end

      s.paginate :page => params[:page]
    end.group(:faculty).groups
  end

  private

  def set_params
    if params[:filter]
      @name = params[:filter][:name] if params[:filter][:name].present?
      @faculty = params[:filter][:faculty] if params[:filter][:faculty].present?
      @approved = params[:filter][:approved] if params[:filter][:approved].present?
    end
  end
end
