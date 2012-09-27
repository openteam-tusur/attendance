class Manage::GroupsController < Manage::ApplicationController
  inherit_resources

  defaults :finder => :find_by_number!

  belongs_to :faculty, :optional => true, :finder => :find_by_abbr!

  actions :all, :only => [:index, :show]

end
