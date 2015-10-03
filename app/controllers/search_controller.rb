require 'tvdb_party'

class SearchController < ApplicationController

    def search
        #Get the query
        @query = params[:query]

        client = TvdbParty::Search.new("")
        @results = client.search(@query)
    end
end
