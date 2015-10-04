class LstController < ApplicationController
  def addToWatchlist
    data = JSON.parse params[:data]
    @lst = Lst.create(user_id: params[:id], series_id: data["series_id"], completed: false)
    
    render json: @lst
  end

  def removeFromWatchlist
    
  end

  def key
#     'X-CSRF-Token': '<%= form_authenticity_token.to_s %>' 
      render json: form_authenticity_token.to_s
  end
  def show
    if params[:id]
      @results = Lst.where(user_id: params[:id]).all()
    else
      @results = Lst.where(user_id: current_user.id).all()
    end
    
    respond_to do |format|
      format.html  
      format.json {render json: @results}
    end
  end
end
