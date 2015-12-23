module Api
  module V1
    class SeriesController < ApplicationController
      #before_action :doorkeeper_authorize!
      
      def show
        series_id = params[:series_id]
    
        if Series.where(id: series_id).first == nil
          respond_to do |format|
            format.html { redirect_to "/watchlist", notice: "No series with that id found"}
          end
        end

        results = Series.getSeasons(series_id)
        render json: results
      end
    end
  end
end
