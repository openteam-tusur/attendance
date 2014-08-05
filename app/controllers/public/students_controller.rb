class Public::StudentsController < ApplicationController
  def show
    @student = Student.find_by(:secure_id => params[:id])
  end
end
