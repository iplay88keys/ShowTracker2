require 'tvdbr'

class LstController < ApplicationController
  before_action :authenticate_user!

  def addToWatchlist
    if Lst.addSeries(params[:user_id], params[:series_id])
      payload = {
          error: "The series was successfully added to the watchlist",
          status: 200
      }
      render :json => payload, :status => :ok
    else
      payload = {
          error: "The series already exists in the user's watchlist",
          status: 409
      }
      render :json => payload, :status => :conflict
    end
  end

  def removeFromWatchlist
    if Lst.removeSeries(params[:user_id], params[:series_id])
      payload = {
        message: "The series has been successfuly removed from the user's watchlist",
        status: 200
      }
      render :json => payload, :status => :ok
    else
      payload = {
        error: "The series does not exist in the user's watchlist",
        status: 404
      }
      render :json => payload, :status => :not_found
    end
  end
  
  def show
    id = params[:id] || current_user.id
    @results = Lst.getWatchlistForUser(id)
    puts @results.inspect
  end
end
