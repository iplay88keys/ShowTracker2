require 'tvdb_party'

class LstController < ApplicationController
  def addToWatchlist
    puts params
    data = params[:series_id]
    
    if Lst.where(user_id: params[:id]).where(series_id: data).first == nil
      @lst = Lst.create(user_id: params[:id], series_id: data, completed: false)
      render json: @lst
    else
      payload = {
          error: "The series already exists in the user's watchlist",
          status: 409
      }
      render :json => payload, :status => :conflict
    end
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
