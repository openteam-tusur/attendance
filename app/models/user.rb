class User < ActiveRecord::Base
  sso_auth_user

  def after_oauth_authentication
    Permission.where(:email => self.email).each {|p| p.update_attribute(:user_id, self.id) }
  end
end
