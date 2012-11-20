class Manage::ApplicationController < ApplicationController
  sso_load_and_authorize_resource
  inherit_resources

  layout 'manage'
end
