class ApplicationController < ActionController::Base
  protect_from_forgery

  layout 'public'

  def identity
    sign_in User.find_or_create_by_omniauth_hash(request.env['omniauth.auth']), :event => :authentication
    flash[:notice] = I18n.t('devise.omniauth_callbacks.success', :kind => I18n.t('sso-auth.provider.title'))
    redirect_to stored_location_for(:user) || main_app.root_path
  end
end
