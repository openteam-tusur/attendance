class Manage::LessonsController < Manage::ApplicationController
  inherit_resources
  belongs_to :group, :finder => :find_by_number!

  has_scope :date do |controller, scope, value|
    scope.by_group_and_date(controller.params['group_id'], value)
  end
end
