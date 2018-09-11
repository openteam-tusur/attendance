class Membership < ActiveRecord::Base
  belongs_to :participate,  :polymorphic => true
  belongs_to :person,       :polymorphic => true

  scope :students, -> { where(participate_type: "Group") }
  scope :actual,      -> { where(:deleted_at => nil) }
end

# == Schema Information
#
# Table name: memberships
#
#  id               :integer          not null, primary key
#  participate_type :string(255)
#  participate_id   :integer
#  person_type      :string(255)
#  person_id        :integer
#  deleted_at       :datetime
#  created_at       :datetime
#  updated_at       :datetime
#
