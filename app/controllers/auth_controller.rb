class AuthController < ApplicationController
  include ApplicationHelper
  inherit_resources
  load_and_authorize_resource
  before_filter        :redirect_to_namespace

  def current_ability
    Ability.new(current_user, current_namespace)
  end

  private
  def redirect_to_namespace
    return if !user_signed_in? || available_user_namespaces.empty?
    return if available_user_namespaces.include?(current_namespace.to_s)
    redirect_to [current_user.permissions.first.role.to_sym, :root]
  end

  def available_user_namespaces
    current_user.permissions.pluck(:role)
  end
end
