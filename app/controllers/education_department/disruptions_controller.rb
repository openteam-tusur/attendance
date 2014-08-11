require 'grouped_realizes'
class EducationDepartment::DisruptionsController < AuthController
  def index
    @disruptions = GroupedRealizes.new.by_faculty
  end
end
