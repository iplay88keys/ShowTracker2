module Api
  module V1
    class SearchController < BaseController
      include Authenticate
      before_action :restrict_access
      
      def search(remote = false)
        results = Series.search(params[:query], remote)

        output = {}
        output["query"] = params[:query]
        output["remote"] = remote
        output["results"] = results

        render json: output
      end

      def searchRemote
        search(true)
      end
    end
  end
end
