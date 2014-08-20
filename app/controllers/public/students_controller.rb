class Public::StudentsController < ApplicationController
  include FilterParams
  include DateRange

  def show
    @student = Student.find_by(:secure_id => params[:id])
    @omissions = @student.presences.by_state(:wasnt).between_dates(*filter_params.values)
  end
end
