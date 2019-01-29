class Subdepartment::StudentsController < AuthController
  include FilterParams
  include DateRange

  before_filter :find_subdepartment

  def show
    @charts = {}
    @group = @subdepartment.groups.actual.find_by(:number => params[:group_id])
    @student = @group.students.actual.find{|s| s.to_s == params[:id] } or not_found
    @omissions = @student.presences.by_state(:wasnt).between_dates(*filter_params.values)
    student_statistic = Statistic::Student.new(@student.contingent_id, nil)

    if params[:course_id]
      @parent_url = subdepartment_course_group_path(params[:course_id], @group.number, :filter => params[:filter])
    else
      @parent_url = subdepartment_group_path(@group.number, :filter => params[:filter])
    end

    @charts['attendance_by_dates.line']      = student_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_disciplines.bar'] = student_statistic.attendance_by('disciplines', **filter_params)
  end

  private

  def find_subdepartment
    @subdepartment = current_user.subdepartments.actual.first
  end
end
