module Api
  module V1
    class SearchController < BaseController
      include Authenticate
      before_action :restrict_access
      
      def search(remote = false)
        results = Series.search(params[:query], remote)

        respond_to do |format|
          render json: params[:query]
          render json: remote
          render :json => results.to_json(:only => [:id, :name, :banner, :overview, :status], :methods => [:banner_url])
        end
      end

      def searchRemote
        search(true)
      end
    end
  end
end
