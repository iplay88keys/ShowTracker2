require 'tvdb_party'

class SearchController < ApplicationController
  include MustBeLoggedIn
  
  before_action :prevent_access
   
  def search
    #Get the query
    @query = params[:query]

    client = TvdbParty::Search.new(Rails.application.secrets.tvdb_api_key)
    @results = client.search(@query)
  end
end
