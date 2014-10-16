class EducationDepartment::GroupLeadersController < AuthController
  include FilterParams
  include DateRange

  before_filter :set_filter_dates, :only => :index

  def index
    @faculties = Faculty.actual
    authorize! :read, GroupLeader
  end

  private

  def set_filter_dates
    @filter = filter_params
  end
end
