require 'tvdbr'

class SearchController < ApplicationController
  include MustBeLoggedIn
  
  before_action :prevent_access
   
  def search
    #Get the query
    @query = params[:query]
    
    # Search the remote database if remote is true
    if params[:remote]
      # Create the client
      client = Tvdbr::Client.new(Rails.application.secrets.tvdb_api_key)
      @results = client.find_all_series_by_title(@query)
      
      # For each result, check if it is stored in the database
      @results.each do |result|
        if Series.where(id: result.id).first == nil
          result = client.find_series_by_id(result.id)
          @series = Series.create(id: result.id, name: result.series_name, banner: result.banner ? result.banner : nil, banner_thumb: result.banner ? result.banner.gsub(/banners\//, "banners/_cache/") : nil, overview: result.overview == nil ? "" : result.overview, status: result.status)
        end
      end
    end

    # Split the query into its individual words
    @results = []
    terms = @query.split(' ')

    # Search based on the terms
    terms.each do |term|
      # Search the series names
      queryResults = Series.where("series.name like ?", "%#{term}%")
      
      # Insert the result into our array to be returned
      queryResults.each do |queryResult|
        insert = true
        @results.each do |result|
          insert = false if result.id == queryResult.id
        end
        @results << queryResult if insert
      end
    end
    
    # Delete any results that don't have the entire search term in their name field
    @results.delete_if do |result|
      remove = false
      terms.each do |term|
        if (!result.name.downcase.include? term.downcase)
          remove = true
        end
      end
      remove
    end
  end
end
