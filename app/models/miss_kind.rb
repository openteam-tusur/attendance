class MissKind < ActiveRecord::Base
  validates_uniqueness_of :kind
  validates_presence_of :kind

  normalize_attribute :kind

  scope :ordered, ->(_) { order('kind desc')  }

  alias_attribute :to_s, :kind
end
