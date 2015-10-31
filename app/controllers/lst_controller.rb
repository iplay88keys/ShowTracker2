require 'tvdbr'

class LstController < ApplicationController
  include MustBeLoggedIn
  
  before_action :prevent_access

  def addToWatchlist
    series_id = params[:series_id]
    id = params[:id]
    
    # If the series isn't in the user's watchlist
    if Lst.where(user_id: id).where(series_id: series_id).first == nil
      # Add it
      @lst = Lst.create(user_id: id, series_id: series_id, completed: false)
      # If the series doesn't exist in our database
      if Series.where(id: series_id).first == nil
        # Pull the information from tvdb
        client = Tvdbr::Client.new(Rails.application.secrets.tvdb_api_key)
        result = client.find_series_by_id(series_id)
        # Create a new series
        @series = Series.create(id: result.id, name: result.series_name, banner: result.banner ? result.banner : nil, banner_thumb: result.banner ? result.banner.gsub(/banners\//, "banners/_cache/") : nil, overview: result.overview == nil ? "" : result.overview, status: result.status, last_updated: result.lastupdated.to_i)
      end
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
    series_id = params[:series_id]
    id = params[:id]
    
    # Get the watchlist item
    element = Lst.where(user_id: id).where(series_id: series_id).first

    if element == nil
      payload = {
        error: "The series does not exist in the user's watchlist",
        status: 404
      }
      render :json => payload, :status => :not_found
    else
      element.destroy
      payload = {
        message: "The series has been successfuly removed from the user's watchlist",
        status: 200
      }
      render :json => payload, :status => :ok
    end
  end

  def key
#     'X-CSRF-Token': '<%= form_authenticity_token.to_s %>' 
      render json: form_authenticity_token.to_s
  end

  def show
    @results = [];
    
    # See someone else's list (or via api)
    if params[:id]
      @results = Series.joins(:lst).where('lsts.user_id = ?', params[:id]).select('series.id, series.name, series.banner, series.banner_thumb, series.overview').all
    else
      @results = Series.joins(:lst).where('lsts.user_id = ?', current_user.id).select('series.id, series.name, series.banner, series.banner_thumb, series.overview').all
    end
    
    respond_to do |format|
      format.html  
      format.json {render json: @results}
    end
  end
end
