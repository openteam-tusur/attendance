class UsersController < ApplicationController
  authorize_resource

  def current_ability
    Ability.new(current_user, :search)
  end

  def search
    search = User.search do
      with(:name).starting_with(params[:term])
    end

    render :json => search.results
  end
end
