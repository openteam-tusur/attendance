class Manage::LessonsController < Manage::ApplicationController
  inherit_resources

  belongs_to :group, :finder => :find_by_number! do
    belongs_to :student, :optional => true
  end

  has_scope :date do |controller, scope, value|
    scope.by_date(value)
  end

  actions :all, :only => :index

  before_filter :set_today

  private
    def set_today
      params[:date] ||= Time.zone.today.to_s
    end
end
