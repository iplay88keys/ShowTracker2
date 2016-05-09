module Api
  module V1
    class EpisodeController < BaseController
      include Authenticate
      before_action :restrict_access
      protect_from_forgery with: :null_session
      
      def addWatched
        user = Authenticate.getKeyUser(request.headers["HTTP_AUTHORIZATION"])
        if Watch.addWatched(params[:ep_id], user, params[:series_id], params[:season_id])
          payload = {
            message: "The episode was successfully marked as watched",
            status: 200
          }
          render :json => payload, :status => :ok
        else
          payload = {
              error: "The episode is already marked as watched",
              status: 409
          }
          render :json => payload, :status => :conflict
        end
      end

      def removeWatched
        user = Authenticate.getKeyUser(request.headers["HTTP_AUTHORIZATION"])
        if Watch.removeWatched(params[:ep_id], user, params[:series_id], params[:season_id])
          payload = {
            message: "The episode was successfully marked as unwatched",
            status: 200
          }
          render :json => payload, :status => :ok
        else
          payload = {
            error: "The episode is already not marked as watched",
            status: 404
          }
          render :json => payload, :status => :not_found
        end
      end
    end
  end
end
