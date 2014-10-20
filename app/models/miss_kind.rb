class MissKind < ActiveRecord::Base
  validates_uniqueness_of :kind

  normalize_attribute :kind

  alias_attribute :to_s, :kind
end
