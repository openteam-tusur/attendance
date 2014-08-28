class Public::StudentsController < ApplicationController
  include FilterParams
  include DateRange

  def show
    @charts = {}
    @student = Student.find_by(:secure_id => params[:id])
    student_statistic = Statistic::Student.new(@student, nil)

    @charts['attendance_by_dates.line']      = student_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_disciplines.bar'] = student_statistic.attendance_by('disciplines', **filter_params)

    @omissions = @student.presences.by_state(:wasnt).between_dates(*filter_params.values)
  end
end
