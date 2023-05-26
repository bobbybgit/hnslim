class UsersController < ApplicationController

  def index
    @players = User.all
  end

end
