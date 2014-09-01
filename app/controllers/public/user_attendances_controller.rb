class Public::UserAttendancesController < ApplicationController
  before_filter :find_context, :only => :show

  def show
    redirect_to root_path and return unless @context
    redirect_to lecturer_groups_path and return if @context.is_a?(Lecturer)
    redirect_to student_path(@context.secure_id) and return if @context.is_a?(Student)
  end

  private

  def find_context
    user = User.find_by(:uid => params[:id])
    @context = user.present? ? user.lecturers.first || user.students.first : nil
  end
end
