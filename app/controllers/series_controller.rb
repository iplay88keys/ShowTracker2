require 'tvdbr'

class SeriesController < ApplicationController
  include MustBeLoggedIn
  def show
    @id = params[:series_id]
    
    if Series.where(id: @id).first == nil
      respond_to do |format|
        format.html { redirect_to "/watchlist", notice: "No series with that id found"}
      end
    end

    client = Tvdbr::Client.new(Rails.application.secrets.tvdb_api_key)
    # First check to see if there are any existing episodes in our db for the series
    if Episode.where(series_id: @id).first == nil
      # If not, get the series and then the episodes for the series
      series = client.find_series_by_id(@id)
      episodes = series.episodes
      ActiveRecord::Base.transaction do
        # Create an Episode object for each episode that doesn't exist in the db
        episodes.each do |episode|
          if Episode.where(id: episode.id).first == nil
            Episode.create(id: episode.id, series_id: episode.seriesid, episode_number: episode.episode_number, name: episode.name, season_number: episode.season_number, season_id: episode.seasonid, overview: episode.overview)
          end
        end
      end
    end
    
    @info = Series.where(id: @id).select('name, poster_thumb, banner, overview').first
    # Get the count of seasons and season names (usually numbers)
    @seasons = Episode.where(series_id: @id).uniq.pluck('season_number, season_id')
    @seasons_count = @seasons.length
    # Remove the "0" season and replace with "Specials" as per the TVDB database's naming convention
    @seasons.each do |season|
      if season[0] == 0
        season[0] = "Specials"
      end
    end
    @seasons.sort_by! {|x| [x[0].to_s, x[1].to_s]}
  end
  
  def addAllWatched
    user_id = params[:user_id]
    series_id = params[:series_id]
    
    if params[:season_id]
      season_id = params[:season_id]
      episodes = Episode.where(series_id: series_id, season_id: season_id).pluck('id')
      ActiveRecord::Base.transaction do
        episodes.each do |episode|
          if Watch.where(user_id: user_id, episode_id: episode, series_id: series_id, season_id: season_id).first == nil
            Watch.create(user_id: user_id, episode_id: episode, series_id: series_id, season_id: season_id)
          end
        end
      end
    else
      episodes = Episode.where(series_id: series_id).pluck('id, season_id')
      
      ActiveRecord::Base.transaction do
        episodes.each do |episode|
          if Watch.where(user_id: user_id, episode_id: episode.id, series_id: series_id, season_id: episode.season_id).first == nil
            Watch.create(user_id: user_id, episode_id: episode.id, series_id: series_id, season_id: episode.season_id)
          end
        end
      end
    end

    payload = {
      error: "The episodes were successfully marked as watched",
      status: 200
    }
    render :json => payload, :status => :ok
  end

  def removeAllWatched
    user_id = params[:user_id]
    series_id = params[:series_id]
    
    if params[:season_id]
      season_id = params[:season_id]
      elements = Watch.where(user_id: user_id, series_id: series_id, season_id: season_id)
    else
      elements = Watch.where(user_id: user_id, series_id: series_id)
    end

    ActiveRecord::Base.transaction do
      elements.each do |element|
        element.destroy
      end
    end

    payload = {
      message: "The episodes were successfully marked as unwatched",
      status: 200
    }
    render :json => payload, :status => :ok
  end
end
