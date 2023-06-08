class UsersController < ApplicationController

  def index
    @players = User.all
    @collections = Collection.all
    @ratings = Rating.all
  end

end
