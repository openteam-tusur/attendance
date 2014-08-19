class Dean::DisruptionsController < AuthController
  actions :index

  def index
    @faculty = current_user.faculties.first
    @disruptions = Kaminari.paginate_array(@faculty.realizes.wasnt.with_lessons.ordered_by_lecturer.group_by(&:lecturer)).page(params[:page]).per(10)
  end
end
