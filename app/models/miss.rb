class Miss < ActiveRecord::Base
  attr_accessor :name

  belongs_to :missing, :polymorphic => true

  validates_presence_of :starts_at, :ends_at, :note
  validates_presence_of :missing_id, :message => 'ФИО не может быть пустым'
  validate :dates_order, :unless => 'starts_at.nil?' && 'ends_at.nil?'

  scope :for_missing, ->(type) { where(:missing_type => type) }
  scope :by_date,     ->(date) { where('starts_at <= :date and ends_at >= :date', :date => date) }

  def absent_period
    "с #{I18n.l(self.starts_at)} по #{I18n.l(self.ends_at)}"
  end

  private

  def dates_order
    errors.add(:dates_in_wrong_order, "Дата 'С' должна быть меньше даты 'По'") if self.starts_at > self.ends_at
  end
end
