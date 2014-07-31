class Miss < ActiveRecord::Base
  belongs_to :missing, :polymorphic => true
end
