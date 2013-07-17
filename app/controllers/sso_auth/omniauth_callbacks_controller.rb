class SsoAuth::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def identity
    sign_in User.find_or_create_by_omniauth_hash(request.env['omniauth.auth']), :event => :authentication
    flash[:notice] = I18n.t('devise.omniauth_callbacks.success', :kind => I18n.t('sso-auth.provider.title'))

    Permission.activate_for_user(current_user)

    redirect_to stored_location_for(:user) || main_app.root_path
  end

  private

  def after_omniauth_failure_path_for(model)
    main_app.root_path
  end
end
