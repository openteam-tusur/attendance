class Manage::GroupsController < Manage::ApplicationController
  inherit_resources

  defaults :finder => :find_by_number!

end
