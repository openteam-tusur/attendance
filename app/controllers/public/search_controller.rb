class Public::SearchController < ApplicationController
  include ApplicationHelper

  def index
    page_title(params[:q])
  end
end
