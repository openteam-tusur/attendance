class Manage::ApplicationController < ApplicationController
  esp_load_and_authorize_resource

  layout 'manage'

  def university_statistics
  end
end
