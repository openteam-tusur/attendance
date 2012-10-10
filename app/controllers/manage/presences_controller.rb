class Manage::PresencesController < Manage::ApplicationController
  belongs_to :group, :finder => :find_by_number! do
    belongs_to :student do
      belongs_to :lesson
    end
  end

  actions :all, :only => [:show, :update, :edit]

  layout false
end
