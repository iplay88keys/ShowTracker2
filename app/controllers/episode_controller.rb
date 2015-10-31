require 'tvdbr'

class EpisodeController < ApplicationController
  include MustBeLoggedIn
  
  before_action :prevent_access

  def show

  end

  def addWatched
    episode_id = params[:ep_id]
    user_id = params[:user_id]
    series_id = params[:series_id]
    season_id = params[:season_id]
    
    if Watch.where(user_id: user_id, episode_id: episode_id, series_id: series_id, season_id: season_id).first == nil
      Watch.create(user_id: user_id, episode_id: episode_id, series_id: series_id, season_id: season_id)
      payload = {
        error: "The episode was successfully marked as watched",
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
    episode_id = params[:ep_id]
    user_id = params[:user_id]
    series_id = params[:series_id]
    season_id = params[:season_id]
    
    element = Watch.where(user_id: user_id, episode_id: episode_id, series_id: series_id, season_id: season_id).first

    if element == nil
      payload = {
        error: "The episode is already not marked as watched",
        status: 404
      }
      render :json => payload, :status => :not_found
    else
      element.destroy
      payload = {
        message: "The episode was successfully marked as unwatched",
        status: 200
      }
      render :json => payload, :status => :ok
    end
  end

end
