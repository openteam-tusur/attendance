class Manage::PresencesController < Manage::ApplicationController
  inherit_resources

  belongs_to :group, :finder => :find_by_number! do
    belongs_to :student do
      belongs_to :lesson
    end
  end

  actions :all, :except => :delete

  layout false
end
