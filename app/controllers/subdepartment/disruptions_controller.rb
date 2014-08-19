class Subdepartment::DisruptionsController < AuthController
  actions :index

  def index
    @subdepartment = current_user.subdepartments.first
    @disruptions = Kaminari.paginate_array(@subdepartment.realizes.wasnt.with_lessons.ordered_by_lecturer.group_by(&:lecturer)).page(params[:page]).per(10)
  end
end
