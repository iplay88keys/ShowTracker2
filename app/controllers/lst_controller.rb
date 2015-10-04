require 'tvdb_party'

class LstController < ApplicationController
  def addToWatchlist
    data = params[:series_id]
    
    if Lst.where(user_id: params[:id]).where(series_id: data).first == nil
      @lst = Lst.create(user_id: params[:id], series_id: data, completed: false)
      client = TvdbParty::Search.new(Rails.application.secrets.tvdb_api_key)
      result = client.get_series_by_id(data)
      if Series.where(id: data).first == nil
        @series = Series.create(id: result.id, name: result.name, banner: result.banners[0], overview: result.overview, status: result.status)
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
    data = params[:series_id]
    
    element = Lst.where(user_id: params[:id]).where(series_id: data).first

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
    if params[:id]
      @results = Lst.includes(:series).where('lsts.user_id = ?', current_user.id).references(:series).select('series.id, series.name, series.banner, series.overview').all    
    else
      @results = Lst.includes(:series).where('lsts.user_id = ?', current_user.id).references(:series).select('series.id, series.name, series.banner, series.overview').all    
    end
    
    respond_to do |format|
      format.html  
      format.json {render json: @results}
    end
  end
end
