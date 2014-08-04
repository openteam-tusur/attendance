class Presence < ActiveRecord::Base
  belongs_to :student
  belongs_to :lesson

  scope :by_student, ->(student) { find_by(:student_id => student.id) }

  def change_state
    state.nil? ? self.state = :was : state == :was ? self.state = :wasnt : self.state = :was
  end

  def to_s
    I18n.t("states.presences.#{state || :empty}")
  end
end
