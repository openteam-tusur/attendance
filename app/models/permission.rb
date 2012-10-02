class Permission < ActiveRecord::Base
  attr_accessible :context, :role, :user_id, :context_id, :context_type, :user_uid, :user_name, :user_email, :user_search, :polymorphic_context
  esp_auth_permission
end

# == Schema Information
#
# Table name: permissions
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  context_id   :integer
#  context_type :string(255)
#  role         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

