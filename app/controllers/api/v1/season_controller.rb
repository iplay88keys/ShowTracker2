module Api
  module V1
    class SeasonController < BaseController
      include Authenticate
      before_action :restrict_access
      
      def show
        user = Authenticate.getKeyUser(request.headers["HTTP_AUTHORIZATION"])
        returned = Episode.getEpisodesForSeasonWithWatches(user, params[:series_id], params[:season_id])
        render :json => returned.to_json(:methods => [:banner_url, :poster_url])
      end

      def all
        user = Authenticate.getKeyUser(request.headers["HTTP_AUTHORIZATION"])
        returned = Episode.getAllEpisodesWithWatches(user, params[:series_id])
        render :json => returned.to_json(:methods => [:banner_url, :poster_url])
      end
    end
  end
end
