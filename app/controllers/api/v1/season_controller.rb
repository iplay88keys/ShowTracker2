module Api
  module V1
    class SeasonController < BaseController
      include Authenticate
      before_action :restrict_access
      
      def show
        @current_user ||= current_user.id
        returned = Episode.getEpisodesForSeasonWithWatches(@current_user, params[:series_id], params[:season_id])
        render json: returned
      end

      def all
        @current_user ||= current_user.id
        returned = Episode.getAllEpisodesWithWatches(@current_user, params[:series_id])
        render json: returned
      end
    end
  end
end
