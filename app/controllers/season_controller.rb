require 'tvdbr'

class SeasonController < ApplicationController
  include MustBeLoggedIn
  def show
    id = params[:series_id]
    season_id = params[:season_id]
    
    info = Series.where(id: id).select('poster_thumb, name').first
    # Get a list of all episodes in that series with a matching season_id
    episodes = Episode.where(series_id: id, season_id: season_id).select('id, season_number, episode_number, name')
    render :template => 'season/show', :locals => { :episodes => episodes, :id => id, :all => false, :info => info }
  end

  def all
    id = params[:series_id]

    info = Series.where(id: id).select('poster_thumb, name').first
    # Get a list of all episodes in that series
    episodes = Episode.where(series_id: id).select('id, season_number, episode_number, name')
    puts episodes
    render :template => 'season/show', :locals => { :episodes => episodes, :id => id, :all => true, :info => info }
  end
end
