class Membership < ActiveRecord::Base
  belongs_to :participate,  :polymorphic => true
  belongs_to :person,       :polymorphic => true
end
