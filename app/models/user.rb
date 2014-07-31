class User < ActiveRecord::Base
  include Gravtastic
  gravtastic
  has_remote_profile
  sso_auth_user

  has_many :curated_groups, -> { where('permissions.role = ?', :curator) },      :through => :permissions, :source => :context, :source_type => 'Group'
  has_many :leaded_groups,  -> { where('permissions.role = ?', :group_leader) }, :through => :permissions, :source => :context, :source_type => 'Group'

  def after_oauth_authentication
    Permission.where(:email => self.email).each {|p| p.update_attribute(:user_id, self.id) }
  end

  def group
    return if permissions.for_role(:group_leader).empty?
    permissions.for_role(:group_leader).first.context
  end
end
