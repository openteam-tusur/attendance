class Membership < ActiveRecord::Base
  belongs_to :participate,  :polymorphic => true
  belongs_to :person,       :polymorphic => true

  scope :students, -> { where(participate_type: "Group") }
  scope :actual,      -> { where(:deleted_at => nil) }
end
