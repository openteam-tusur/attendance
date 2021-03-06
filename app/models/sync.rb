class Sync < ActiveRecord::Base
 extend Enumerize
 enumerize :state, :in => [:success, :failure], :default => :success, :predicates => true

 after_create :write_log

 def sync_logger
   @@sync_logger ||= Logger.new("#{Rails.root}/log/sync.log")
 end

 def write_log
   sync_logger.info title
 end
end

# == Schema Information
#
# Table name: syncs
#
#  id         :integer          not null, primary key
#  state      :string(255)
#  title      :text
#  created_at :datetime
#  updated_at :datetime
#
