class Public::MainPageController < ApplicationController
  def index
    if user_signed_in? && available_user_namespaces.any?
      redirect_to [current_user.permissions.first.role.to_sym, :root]
    end
  end

  private

  def available_user_namespaces
    @available_user_namespaces ||= current_user.permissions.pluck(:role)
  end
end
