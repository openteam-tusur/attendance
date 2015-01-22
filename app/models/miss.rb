class Miss < ActiveRecord::Base
  attr_accessor :name

  after_save    :set_statistic
  after_destroy :set_statistic_after_destroy

  belongs_to :missing, :polymorphic => true
  belongs_to :miss_kind

  validates_presence_of :starts_at, :ends_at, :miss_kind_id
  validates_presence_of :missing_id, :message => 'ФИО не может быть пустым'
  validate :dates_order, :unless => 'starts_at.nil?' && 'ends_at.nil?'

  normalize_attribute :note

  scope :for_missing,  ->(type) { where(:missing_type => type) }
  scope :by_date,      ->(date) { where('starts_at <= :date and ends_at >= :date', :date => date) }
  scope :between_dates, ->(starts_at, ends_at) { where('starts_at >= :starts_at and starts_at <= :ends_at or ends_at >= :starts_at and ends_at <= :ends_at', :starts_at => starts_at, :ends_at => ends_at) }
  scope :ordered,      ->(_)    { order('created_at') }

  def absent_period
    "с #{I18n.l(self.starts_at)} по #{I18n.l(self.ends_at)}"
  end

  private

  def dates_order
    errors.add(:dates_in_wrong_order, "Дата 'С' должна быть меньше даты 'По'") if self.starts_at > self.ends_at
  end

  def set_statistic
    prev_starts_at, new_starts_at = changes['starts_at']
    prev_ends_at, new_ends_at = changes['ends_at']
    old_scope = missing.presences.between_dates(prev_starts_at, prev_ends_at).by_state('wasnt')
    new_scope = missing.presences.between_dates(new_starts_at, new_ends_at).by_state('wasnt')
    puts (old_scope+new_scope).uniq.inspect
    (old_scope+new_scope).uniq.each {|p| p.update_attributes(:updated_at => Time.zone.now)}
  end

  def set_statistic_after_destroy
    missing.presences.between_dates(starts_at, ends_at).by_state('wasnt').each {|p| p.update_attributes(:updated_at => Time.zone.now)}
  end
end
