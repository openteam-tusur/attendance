require 'student_searcher'

class Dean::StudentsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  authorize_resource

  before_filter :build_faculty, :only => [:index, :search, :show]

  def index
    index!{
      @students = Kaminari.paginate_array(@faculty.students.select {|s| s.slacker?(**filter_params)}).page(params[:page])
      @params = filter_params
    }
  end

  def show
    @charts = {}
    @subdepartment = @faculty.subdepartments.actual.find_by(:abbr => params[:subdepartment_id])
    @group = @subdepartment.groups.actual.find_by(:number => params[:group_id])
    @student = @group.students.actual.find{|s| s.to_s == params[:id] }
    @omissions = @student.presences.by_state(:wasnt).between_dates(*filter_params.values)
    @course  = params[:course_id]
    student_statistic = Statistic::Student.new(@student.contingent_id, nil)

    if params.to_a[-3..-2][0][0] == 'course_id'
      @parent_url = dean_subdepartment_course_group_path(@subdepartment.abbr, @course, @group.number, :filter => params[:filter])
    else
      @parent_url = dean_course_subdepartment_group_path(@course, @subdepartment.abbr, @group.number, :filter => params[:filter])
    end

    @charts['attendance_by_dates.line']      = student_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_disciplines.bar'] = student_statistic.attendance_by('disciplines', **filter_params)
  end

  def search
    @students = if params[:term].present?
                  StudentSearcher.new(params.merge(:faculty_id => @faculty.id)).autocomplete_search.results
                else
                  []
                end
    render :text => @students.to_json
  end

  private

  def build_faculty
    @faculty = current_user.permissions.for_role(:dean).first.try(:context) if current_user.present?
  end
end
