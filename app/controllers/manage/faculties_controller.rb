class Manage::FacultiesController < Manage::ApplicationController
  inherit_resources

  defaults :finder => :find_by_abbr!

  actions :show
end
