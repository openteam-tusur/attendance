class ApplicationController < ActionController::Base
  protect_from_forgery

  layout 'public'

  def main_page
  end
end
