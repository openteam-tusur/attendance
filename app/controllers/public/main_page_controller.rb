class Public::MainPageController < ApplicationController
  def index
    if user_signed_in?
      if available_user_namespaces.any?
        permission = PriorityPermission.new(current_user).fetch
        redirect_to [permission.role.to_sym, :root] and return
      end
      if current_user.student
        redirect_to student_path(current_user.student.secure_id) and return
      end
    end
  end

  private

  def available_user_namespaces
    @available_user_namespaces ||= current_user.permissions.pluck(:role)
  end
end
