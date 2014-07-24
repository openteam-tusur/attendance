class User < ActiveRecord::Base
  include Gravtastic
  gravtastic
  has_remote_profile
  sso_auth_user

  def after_oauth_authentication
    Permission.where(:email => self.email).each {|p| p.update_attribute(:user_id, self.id) }
  end

  def group
    return if permissions.for_role(:group_leader).empty?
    permissions.for_role(:group_leader).first.context
  end
end
