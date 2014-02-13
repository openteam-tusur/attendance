class Manage::NotMarkedController < ApplicationController
  layout 'manage'

  before_filter :find_group
  before_filter :authorize_user
  rescue_from CanCan::AccessDenied do |exception|
    render :file => "#{Rails.root}/public/403", :formats => [:html], :status => 403, :layout => false
  end

  def index
    @days = @group.presences.joins(:lesson)
              .select('presences.date_on')
              .where("lessons.state = 'took_place'")
              .where('lessons.group_id' => @group.id)
              .where("presences.kind = 'not_marked'")
              .where('presences.date_on BETWEEN ? AND ?', Presence.semester_begin, Time.zone.now).map(&:date_on).uniq.sort
  end

private
  def find_group
    @group = current_user.groups.find_by_number!(params[:id])
  end

  def authorize_user
    authorize! :manage, Presence
  end
end
