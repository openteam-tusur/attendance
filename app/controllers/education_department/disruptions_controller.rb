require 'grouped_realizes'
class EducationDepartment::DisruptionsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  def index
    @faculties = Faculty.all
    @disruptions = Realize.search do
      with(:lecturer).starting_with(params[:name]) if params[:name].present?
      with(:lesson_date).between(filter_params[:from]..filter_params[:to])
      with :faculty, params[:faculty] if params[:faculty].present?
      with :approved, params[:approved] == 1 ? true : false unless params[:approved].nil?
      with :state, :wasnt

      order_by(:lesson_date)
      group :faculty do
        limit 10000
      end

      paginate :page => params[:page], :per_page => 10
    end.group(:faculty).groups
  end
end
