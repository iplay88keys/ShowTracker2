require 'tvdbr'

class SearchController < ApplicationController
  before_action :authenticate_user!
   
  def search
    remote = params[:remote] != nil ? true : false
    @query = params[:query]
    @results = Series.search(@query, remote)
  end
end
