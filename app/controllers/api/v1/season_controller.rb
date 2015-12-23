module Api
  module V1
    class SeasonController < ApplicationController
      #before_action :doorkeeper_authorize!
      
      def show
        returned = Episode.getEpisodesForSeasonWithWatches(current_user.id, params[:series_id], params[:season_id])
        render json: returned
      end

      def all
        returned = Episode.getAllEpisodesWithWatches(current_user.id, params[:series_id])
        render json: returned
      end
    end
  end
end
