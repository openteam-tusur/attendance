require 'lecturer_searcher'

class EducationDepartment::LecturersController < AuthController
  actions :index

  def index
    index!{
      @lecturers = if params[:term].present?
                    LecturerSearcher.new(params).autocomplete_search.results
                  else
                    []
                  end
      render :text => @lecturers.to_json and return
    }
  end
end
