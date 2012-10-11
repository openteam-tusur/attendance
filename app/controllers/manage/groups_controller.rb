class Manage::GroupsController < Manage::ApplicationController
  defaults :finder => :find_by_number!

  belongs_to :faculty, :optional => true, :finder => :find_by_abbr!

  actions :index, :show
end
