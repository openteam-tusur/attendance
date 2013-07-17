class Manage::Statistics::GroupLeadersController < ApplicationController
  layout 'manage'

  rescue_from CanCan::AccessDenied do |exception|
    render :file => "#{Rails.root}/public/403", :formats => [:html], :status => 403, :layout => false
  end

  def index
    @faculties = Hash[
      Faculty.all.map { |f| [f, f.loser_group_leaders(params[:starts_on], params[:ends_on])] }
    ]
    authorize! :read_statistics, :faculties
  end

  def show
    @faculty = Faculty.find_by_abbr!(params[:faculty_abbr])
    @groups = @faculty.loser_group_leaders(params[:starts_on], params[:ends_on])
    authorize! :read_statistics, @faculty
  end

end
