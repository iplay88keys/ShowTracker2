class SeriesController < ApplicationController
  before_action :authenticate_user!

  def show
    series_id = params[:series_id]
    
    if Series.where(id: series_id).first == nil
      respond_to do |format|
        format.html { redirect_to "/watchlist", notice: "No series with that id found"}
      end
    end
    results = Series.getSeasons(series_id)
    @info = results["info"]
    @season_count = results["season_count"]
    @seasons = results["seasons"]
    @id = series_id
  end
  
  def addAllWatched
    result = nil
    if params[:season_id]
      result = Watch.addAllWatched(params[:user_id], params[:series_id], params[:season_id])
    else
      result = Watch.addAllWatched(params[:user_id], params[:series_id])
    end
    if result
      payload = {
        message: "The episodes were successfully marked as watched",
        status: 200
      }
      render :json => payload, :status => :ok
    else
      payload = {
        error: "The episodes were already marked as watched",
        status: 409
      }
      render :json => payload, :status => :conflict
    end
  end

  def removeAllWatched
    if Watch.removeAllWatched(params[:user_id], params[:series_id], params[:season_id])
      payload = {
        message: "The episodes were successfully marked as unwatched",
        status: 200
      }
      render :json => payload, :status => :ok
    else
      payload = {
        error: "The episodes were already marked as unwatched",
        status: 409
      }
      render :json => payload, :status => :conflict
    end
  end
end
