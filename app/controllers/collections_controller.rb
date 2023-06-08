class CollectionsController < ApplicationController

  def delete  
    collection = Collection.find_by_id(params[:id])
    user_id = collection.user_id
    collection.delete
    redirect_to games_table_path(id: user_id), data:{turbo_frame: "games_table"}, notice: "Game was successfully destroyed.", :status => :see_other
  end

end
