require 'grouped_realizes'
class EducationDepartment::DisruptionsController < AuthController
  inherit_resources
  load_and_authorize_resource

  def index
    @disruptions = GroupedRealizes.new.by_faculty
  end
end
