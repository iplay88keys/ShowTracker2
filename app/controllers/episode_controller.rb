require 'tvdbr'

class EpisodeController < ApplicationController
  before_action :authenticate_user!

  def addWatched
    if Watch.addWatched(params[:ep_id], params[:user_id], params[:series_id], params[:season_id])
      payload = {
        message: "The episode was successfully marked as watched",
        status: 200
      }
      render :json => payload, :status => :ok
    else
      payload = {
          error: "The episode is already marked as watched",
          status: 409
      }
      render :json => payload, :status => :conflict
    end
  end

  def removeWatched
    if Watch.removeWatched(params[:ep_id], params[:user_id], params[:series_id], params[:season_id])
      payload = {
        message: "The episode was successfully marked as unwatched",
        status: 200
      }
      render :json => payload, :status => :ok
    else
      payload = {
        error: "The episode is already not marked as watched",
        status: 404
      }
      render :json => payload, :status => :not_found
    end
  end
end
