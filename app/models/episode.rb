class Episode < ActiveRecord::Base
  belongs_to :series
  has_many :users, through: :watches
  has_many :watches

  def self.getEpisodesForSeasonWithWatches(user_id, series_id, season_id)
    watches = Watch.where(user_id: user_id, series_id: series_id, season_id: season_id).pluck('episode_id')
    info = Series.where(id: series_id).first

    extras = {}
    extras["season_id"] = season_id
    extras["series_id"] = series_id

    # Get a list of all episodes in that series with a matching season_id
    episodes = Episode.where(series_id: series_id, season_id: season_id)

    output = {}
    output["watches"] = watches
    output["episodes"] = episodes
    output["info"] = info
    output["extras"] = extras
    output["all"] = false

    return output
  end

  def self.getAllEpisodesWithWatches(user_id, series_id)
    watches = Watch.where(user_id: user_id, series_id: series_id).pluck('episode_id')
    info = Series.where(id: series_id).first

    extras = {}
    extras["series_id"] = series_id

    # Get a list of all episodes in that series
    episodes = Episode.where(series_id: series_id).select('id, season_id, season_number, episode_number, name')

    output = {}
    output["watches"] = watches
    output["episodes"] = episodes
    output["info"] = info
    output["extras"] = extras
    output["all"] = true

    return output
  end
end
