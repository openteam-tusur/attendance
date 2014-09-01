require 'student_searcher'
class Public::SearchController < ApplicationController
  include ApplicationHelper

  def index
    page_title(params[:q])

    @results = if params[:q].present?
                 StudentSearcher.new(params).search.results
               else
                 []
               end

    redirect_to student_path(@results.first.secure_id) if @results.one?
  end
end
