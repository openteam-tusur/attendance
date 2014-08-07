require 'student_searcher'

class Dean::StudentsController < AuthController
  actions :index

  before_filter :build_faculty, :only => [:index]

  def index
    index!{
      @students = if params[:term].present?
                    StudentSearcher.new(params.merge(:faculty_id => @faculty.id)).autocomplete_search.results
                  else
                    []
                  end
      render :text => @students.to_json and return
    }
  end

  private

  def build_faculty
    @faculty = current_user.permissions.for_role(:dean).first.try(:context) if current_user.present?
  end
end
