class Public::StudentsController < ApplicationController
  include FilterParams
  include DateRange

  def show
    @student = Student.find_by(:secure_id => params[:id])
    student_statistic = Statistic::Student.new(@student)
    @attendance_by_date = student_statistic.attendance_by_date(**filter_params)
    @attendance_by_discipline = student_statistic.attendance_by('disciplines', **filter_params)
    @omissions = @student.presences.by_state(:wasnt).between_dates(*filter_params.values)
  end
end
