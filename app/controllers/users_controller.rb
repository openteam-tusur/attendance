require 'open-uri'

class UsersController < ApplicationController
  authorize_resource

  def current_ability
    Ability.new(current_user, :search)
  end

  def search
    url = "#{Settings['profile.url']}/users/search?term=#{params[:term]}"

    result = open(URI.encode(url)).read

    render :json => result
  end
end
