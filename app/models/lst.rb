class Lst < ActiveRecord::Base
  belongs_to :user
  belongs_to :series

  def self.addSeries(user_id, series_id)
    # If the series isn't in the user's watchlist
    if Lst.where(user_id: user_id).where(series_id: series_id).first == nil
      # Add it
      @lst = Lst.create(user_id: user_id, series_id: series_id, completed: false)
      # If the series doesn't exist in our database
      if Series.where(id: series_id).first == nil
        # Pull the information from tvdb
        client = Tvdbr::Client.new(Rails.application.secrets.tvdb_api_key)
        result = client.find_series_by_id(series_id)
        # Create a new series
        @series = Series.create(id: result.id, name: result.series_name, banner: URI.parse(result.banner) ? result.banner : nil, overview: result.overview == nil ? "" : result.overview, status: result.status, last_updated: result.lastupdated.to_i)
      end
      return true
    else
      return false
    end
  end

  def self.removeSeries(user_id, series_id)
    # Get the watchlist item
    element = Lst.where(user_id: user_id).where(series_id: series_id).first

    if element != nil
      element.destroy
      return true
    else
      return false
    end
  end

  def self.getWatchlistForUser(user_id)
    results = []
    # See someone else's list (or via api)
    results = Series.joins(:lst).where('lsts.user_id = ?', user_id).all

    return results
  end
end
