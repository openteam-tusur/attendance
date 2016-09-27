class AuthController < ApplicationController
  include ApplicationHelper

  before_filter :check_current_user

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  def current_ability
    Ability.new(current_user, current_namespace)
  end

  private

  def check_current_user
    redirect_to root_path and return if current_user.blank?
  end
end
