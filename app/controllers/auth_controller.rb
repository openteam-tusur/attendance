class AuthController < ApplicationController
  include ApplicationHelper

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def current_ability
    Ability.new(current_user, current_namespace)
  end
end
