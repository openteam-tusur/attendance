class Public::SearchController < ApplicationController
  def index
    @search = Student.search do
      keywords params[:student][:search]
    end

    @students = @search.results
  end
end
