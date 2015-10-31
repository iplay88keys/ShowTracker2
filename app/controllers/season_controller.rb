require 'tvdbr'

class SeasonController < ApplicationController
  include MustBeLoggedIn
  def show
    id = params[:series_id]
    season_id = params[:season_id]
    
    watches = Watch.where(user_id: current_user.id, series_id: id, season_id: season_id).pluck('episode_id')
    info = Series.where(id: id).select('poster_thumb, name').first
    # Get a list of all episodes in that series with a matching season_id
    episodes = Episode.where(series_id: id, season_id: season_id).select('id, season_id, season_number, episode_number, name')
    render :template => 'season/show', :locals => { :episodes => episodes, :id => id, :all => false, :info => info, :watches => watches }
  end

  def all
    id = params[:series_id]

    watches = Watch.where(user_id: current_user.id, series_id: id).select('episode_id')
    info = Series.where(id: id).select('poster_thumb, name').first
    # Get a list of all episodes in that series
    episodes = Episode.where(series_id: id).select('id, season_id, season_number, episode_number, name')
    render :template => 'season/show', :locals => { :episodes => episodes, :id => id, :all => true, :info => info, :watches => watches }
  end
end
