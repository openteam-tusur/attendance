class Realize < ActiveRecord::Base
  belongs_to :lecturer
  belongs_to :lesson
  after_initialize :set_state

  def to_s
    I18n.t("states.realizes.#{state}")
  end

  private
  def set_state
    self.state ||= :was
  end
end
