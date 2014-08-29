class GroupLeader::StudentsController < AuthController
  include FilterParams
  include DateRange

  def show
    @charts = {}
    @group = current_user.leaded_groups.actual.first
    @student = @group.students.actual.find{|s| s.to_s == params[:id] }
    student_statistic = Statistic::Student.new(@student.contingent_id, nil)
    @charts['attendance_by_dates.line']      = student_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_disciplines.bar'] = student_statistic.attendance_by('disciplines', **filter_params)
  end
end
