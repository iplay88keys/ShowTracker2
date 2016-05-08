module Api
  module V1
    class SeriesController < BaseController
      include Authenticate
      before_action :restrict_access
      
      def show
        series_id = params[:series_id]

        results = Series.getSeasons(series_id)
        render json: results
      end
    end
  end
end
