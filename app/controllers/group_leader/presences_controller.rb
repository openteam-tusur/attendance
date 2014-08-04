class GroupLeader::PresencesController < AuthController
  custom_actions :resource => :change

  def change
    @presence.change_state
    @presence.save
  end
end
