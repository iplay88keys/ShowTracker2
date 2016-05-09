require 'tvdbr'

class Series < ActiveRecord::Base
  has_many :episodes
  has_many :lst
  has_many :users, through: :watches
  has_many :episodes, through: :watches
  has_many :watches

  def self.getSeasons(series_id)
    # First check to see if there are any existing episodes in our db for the series
    if Episode.where(series_id: series_id).first == nil
      client = Tvdbr::Client.new(Rails.application.secrets.tvdb_api_key)
      # If not, get the series and then the episodes for the series
      series = client.find_series_by_id(series_id)
      episodes = series.episodes
      ActiveRecord::Base.transaction do
        # Create an Episode object for each episode that doesn't exist in the db
        episodes.each do |episode|
          if Episode.where(id: episode.id).first == nil
            Episode.create(id: episode.id, series_id: episode.seriesid, episode_number: episode.episode_number, name: episode.name, season_number: episode.season_number, season_id: episode.seasonid, overview: episode.overview)
          end
        end
      end
    end
    
    info = Series.where(id: series_id).select('id, name, poster_thumb, banner, banner_thumb, overview').first
    # Get the count of seasons and season names (usually numbers)
    seasons = Episode.where(series_id: series_id).uniq.pluck('season_number, season_id')
    seasons_count = seasons.length
    seasons.sort!
    # Remove the "0" season and replace with "Specials" as per the TVDB database's naming convention
    seasons.each do |season|
      if season[0] == 0
        season[0] = "Specials"
      end
    end
    
    output = {}
    output["info"] = info
    output["seasons_count"] = seasons_count
    output["seasons"] = seasons
    return output
  end

  def self.search(query, remote)
    # Search the remote database if remote is true
    if remote
      puts "searching remote"
      # Create the client
      client = Tvdbr::Client.new(Rails.application.secrets.tvdb_api_key)
      results = client.find_all_series_by_title(query)
      
      # For each result, check if it is stored in the database
      results.each do |result|
        if Series.where(id: result.id).first == nil
          result = client.find_series_by_id(result.id)
          Series.create(id: result.id, name: result.series_name, poster: result.poster ? result.poster : nil, poster_thumb: result.poster ? result.poster.gsub(/banners\//, "banners/_cache/") : nil, banner: result.banner ? result.banner : nil, banner_thumb: result.banner ? result.banner.gsub(/banners\//, "banners/_cache/") : nil, overview: result.overview == nil ? "" : result.overview, status: result.status, last_updated: result.lastupdated.to_i)
        end
      end
    end

    # Split the query into its individual words
    results = []
    terms = query.split(' ')

    # Search based on the terms
    terms.each do |term|
      # Search the series names
      queryResults = Series.where("series.name ilike ?", "%#{term}%").select('series.id, series.name, series.banner, series.banner_thumb, series.overview')
      
      # Insert the result into our array to be returned
      queryResults.each do |queryResult|
        insert = true
        results.each do |result|
          insert = false if result.id == queryResult.id
        end
        results << queryResult if insert
      end
    end
    
    # Delete any results that don't have the entire search term in their name field
    results.delete_if do |result|
      remove = false
      terms.each do |term|
        if (!result.name.downcase.include? term.downcase)
          remove = true
        end
      end
      remove
    end

    return results
  end
end
