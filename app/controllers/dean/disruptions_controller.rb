class Dean::DisruptionsController < AuthController
  actions :index

  def index
      @disruptions = Realize.wasnt.with_lessons.ordered.group_by(&:lecturer)
  end
end
