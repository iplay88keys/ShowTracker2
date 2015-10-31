require 'tvdbr'

class EpisodeController < ApplicationController
  include MustBeLoggedIn
  
  before_action :prevent_access

  def show

  end

  def addWatched
    series_id = params[:series_id]
    id = params[:id]
    
    if Lst.where(user_id: id).where(series_id: series_id).first == nil
      @episode = Lst.create(user_id: id, series_id: series_id, completed: false)
      if Series.where(id: series_id).first == nil
        client = Tvdbr::Client.new(Rails.application.secrets.tvdb_api_key)
        result = client.find_series_by_id(series_id)
        @series = Series.create(id: result.id, name: result.series_name, banner: result.banner ? result.banner : nil, banner_thumb: result.banner ? result.banner.gsub(/banners\//, "banners/_cache/") : nil, overview: result.overview == nil ? "" : result.overview, status: result.status, last_updated: result.lastupdated.to_i)
      end
      render json: @lst
    else
      payload = {
          error: "The episode is already marked as watched",
          status: 409
      }
      render :json => payload, :status => :conflict
    end
  end

  def removeWatched
    series_id = params[:series_id]
    id = params[:id]
    
    element = Lst.where(user_id: id).where(series_id: series_id).first

    if element == nil
      payload = {
        error: "The episode is already not marked as watched",
        status: 404
      }
      render :json => payload, :status => :not_found
    else
      element.destroy
      payload = {
        message: "The episode has successfully marked as unwatched",
        status: 200
      }
      render :json => payload, :status => :ok
    end
  end

end
