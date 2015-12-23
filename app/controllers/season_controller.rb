class SeasonController < ApplicationController
  before_action :authenticate_user!

  def show
    returned = Episode.getEpisodesForSeasonWithWatches(current_user.id, params[:series_id], params[:season_id])
    render :template => 'season/show', :locals => { :episodes => returned["episodes"], :id => params[:series_id], :all => returned["all"], :info => returned["info"], :watches => returned["watches"], :extras => returned["extras"] }
  end

  def all
    returned = Episode.getAllEpisodesWithWatches(current_user.id, params[:series_id])
    render :template => 'season/show', :locals => { :episodes => returned["episodes"], :id => params[:series_id], :all => returned["all"], :info => returned["info"], :watches => returned["watches"], :extras => returned["extras"] }
  end
end
