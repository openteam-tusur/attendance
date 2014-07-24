class Membership < ActiveRecord::Base
  belongs_to :person,       :polymorphic => true
  belongs_to :participate,  :polymorphic => true
end
