require 'tvdb_party'

class SearchController < ApplicationController
  include MustBeLoggedIn
  
  before_action :prevent_access
   
  def search
    #Get the query
    @query = params[:query]
    
    #Search the remote database if remote is true
    if params[:remote]
      searchRemote @query
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

    @results.delete_if do |result|
      remove = false
      terms.each do |term|
        if (!result.name.downcase.include? term.downcase)
          remove = true
        end
      end
      remove
    end
    puts @results
  end

  def searchRemote query
    @query = query

    client = TvdbParty::Search.new(Rails.application.secrets.tvdb_api_key)
    @results = client.search(@query)
    
    if Series.where(id: data).first == nil
        banners = result.banners.select {|banner| /graphical/ =~ banner.path}
      @series = Series.create(id: result.id, name: result.name, banner: banners[0] ? banners[0].url : nil, banner_thumb: banners[0] ? banners[0].thumb_url : nil, overview: result.overview == nil ? "" : result.overview, status: result.status)
    end
  end
end
