class Public::StudentsController < ApplicationController
  def show
    @student = Student.find_by(:secure_id => params[:id])
    @omissions = @student.presences.by_state(:wasnt)
  end
end
