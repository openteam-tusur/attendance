class Subcontext < ActiveRecord::Base
  esp_auth_subcontext
end

# == Schema Information
#
# Table name: subcontexts
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  context_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

