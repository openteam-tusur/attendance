class Miss < ActiveRecord::Base
  attr_accessor :name

  belongs_to :missing, :polymorphic => true

  scope :for_missing, ->(type) { where(:missing_type => type) }

  def absent_period
    "с #{I18n.l(self.starts_at)} по #{I18n.l(self.ends_at)}"
  end
end
