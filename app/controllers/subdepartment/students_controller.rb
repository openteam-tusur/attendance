class Subdepartment::StudentsController < AuthController
  include FilterParams
  include DateRange

  before_filter :find_subdepartment

  def show
    @charts = {}
    @group = @subdepartment.groups.actual.find_by(:number => params[:group_id])
    @student = @group.students.actual.find{|s| s.to_s == params[:id] }
    student_statistic = Statistic::Student.new(@student.contingent_id, nil)
    @charts['attendance_by_dates.line']      = student_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_disciplines.bar'] = student_statistic.attendance_by('disciplines', **filter_params)
  end

  private

  def find_subdepartment
    @subdepartment = current_user.subdepartments.actual.first
  end
end
