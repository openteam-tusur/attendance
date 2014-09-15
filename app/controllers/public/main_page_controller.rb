class Public::MainPageController < ApplicationController
  def index
    if user_signed_in? && available_user_namespaces.any?
      permission = current_user.permissions.first
      if permission.role == 'student'
        redirect_to student_path(permission.context.secure_id)
      else
        redirect_to [permission.role.to_sym, :root]
      end
    end
  end

  private

  def available_user_namespaces
    @available_user_namespaces ||= current_user.permissions.pluck(:role)
  end
end
