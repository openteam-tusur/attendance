class Manage::UniversityStatisticsController < ApplicationController
  layout 'manage'

  rescue_from CanCan::AccessDenied do |exception|
    render :file => "#{Rails.root}/public/403", :formats => [:html], :status => 403, :layout => false
  end

  def index
    authorize! :read, :university_statistics
  end
end
