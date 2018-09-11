class MissKind < ActiveRecord::Base
  validates_uniqueness_of :kind
  validates_presence_of :kind

  normalize_attribute :kind

  scope :ordered, ->(_) { order('kind') }

  alias_attribute :to_s, :kind
end

# == Schema Information
#
# Table name: miss_kinds
#
#  id         :integer          not null, primary key
#  kind       :string(255)
#  created_at :datetime
#  updated_at :datetime
#
