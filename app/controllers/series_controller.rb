require 'tvdbr'

class SeriesController < ApplicationController
  include MustBeLoggedIn
  def show
    id = params[:id]
    
    if Series.where(id: id).first == nil
      respond_to do |format|
        format.html { redirect_to "/watchlist", notice: "No series with that id found"}
      end
    end

    client = Tvdbr::Client.new(Rails.application.secrets.tvdb_api_key)
    # First check to see if there are any existing episodes in our db for the series
    if Episode.where(series_id: id).first == nil
      # If not, get the series and then the episodes for the series
      series = client.find_series_by_id(id)
      episodes = series.episodes
      ActiveRecord::Base.transaction do
        # Create a Episode object for each episode that doesn't exist in the db
        episodes.each do |episode|
          if Episode.where(id: episode.id).first == nil
            Episode.create(id: episode.id, series_id: episode.seriesid, name: episode.name, season: episode.season_number, season_id: episode.seasonid, overview: episode.overview)
          end
        end
      end
    end

    @episodes = Episode.where(series_id: id).select('episodes.id, episodes.name, episodes.season, episodes.season_id, episodes.overview')
    @season_count = @episodes.class
  end
end
