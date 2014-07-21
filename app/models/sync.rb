class Sync < ActiveRecord::Base
 extend Enumerize
 enumerize :state, :in => [:success, :failure], :default => :success, :predicates => true
end
