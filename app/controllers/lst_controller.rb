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
    @lst = Lst.where(user_id: params[:id]).all()
    
    render json: @lst
  end
end
