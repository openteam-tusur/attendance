class Public::SearchController < ApplicationController
  def index
    fio, group_number = params[:student][:search].split(',').map(&:strip)

    @search = Student.search do
      with :fio, fio
      with :group_number, group_number
    end

    @students = @search.results
  end
end
