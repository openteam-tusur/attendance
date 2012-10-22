class Public::SearchController < ApplicationController
  def index
    surname, name, group_number = params[:student][:search].split(/[^[:alnum:]-]+/)

    group_number="non existent group" unless surname.presence && name.presence && group_number.presence

    @search = Student.search do
      keywords surname, :fields => :surname
      keywords name, :fields => :name
      keywords group_number, :fields => :group_number
    end

    @students = @search.results
  end
end
