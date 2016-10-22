module Api
  module V1
    class LstController < BaseController
      include Authenticate
      before_action :restrict_access
      skip_before_filter :verify_authenticity_token

      def addToWatchlist
        if Lst.addSeries(params[:id], params[:series_id])
          payload = {
              error: "The series was successfully added to the watchlist",
              status: 200
          }
          render :json => payload, :status => :ok
        else
          payload = {
              error: "The series already exists in the user's watchlist",
              status: 409
          }
          render :json => payload, :status => :conflict
        end
      end

      def removeFromWatchlist
        if Lst.removeSeries(params[:id], params[:series_id])
          payload = {
            message: "The series has been successfuly removed from the user's watchlist",
            status: 200
          }
          render :json => payload, :status => :ok
        else
          payload = {
            error: "The series does not exist in the user's watchlist",
            status: 404
          }
          render :json => payload, :status => :not_found
        end
      end

      def show
        user = Authenticate.getKeyUser(request.headers["HTTP_AUTHORIZATION"])
        if params[:id]
          user = params[:id]
        end

        results = Lst.getWatchlistForUser(user)

        render :json => results.to_json(:only => [:id, :name, :banner, :overview, :status], :methods => [:banner_url])
      end
    end
  end
end
