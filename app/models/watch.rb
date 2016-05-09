class Watch < ActiveRecord::Base
  belongs_to :episode
  belongs_to :user
  belongs_to :series

  def self.addWatched(episode_id, user_id, series_id, season_id)
    if Watch.where(user_id: user_id, episode_id: episode_id, series_id: series_id, season_id: season_id).first == nil
      Watch.create(user_id: user_id, episode_id: episode_id, series_id: series_id, season_id: season_id)
      return true
    else
      return false
    end
  end

  def self.removeWatched(episode_id, user_id, series_id, season_id)
    element = Watch.where(user_id: user_id, episode_id: episode_id, series_id: series_id, season_id: season_id).first
    
    if element != nil
      element.destroy
      return true
    else
      return false
    end
  end

  def self.addAllWatched(user_id, series_id, season_id = nil)
    if season_id != nil
      episodes = Episode.where(series_id: series_id, season_id: season_id).pluck('id')
      ActiveRecord::Base.transaction do
        episodes.each do |episode|
          if Watch.where(user_id: user_id, episode_id: episode, series_id: series_id, season_id: season_id).first == nil
            Watch.create(user_id: user_id, episode_id: episode, series_id: series_id, season_id: season_id)
          end
        end
      end
    else
      episodes = Episode.where(series_id: series_id).pluck('id, season_id')
      ActiveRecord::Base.transaction do
        episodes.each do |episode|
          if Watch.where(user_id: user_id, episode_id: episode[0], series_id: series_id, season_id: episode[1]).first == nil
            Watch.create(user_id: user_id, episode_id: episode[0], series_id: series_id, season_id: episode[1])
          end
        end
      end
    end
    return true
  end

  def self.removeAllWatched(user_id, series_id, season_id = nil)
    if season_id != nil
      elements = Watch.where(user_id: user_id, series_id: series_id, season_id: season_id)
    else
      elements = Watch.where(user_id: user_id, series_id: series_id)
    end

    ActiveRecord::Base.transaction do
      elements.each do |element|
        element.destroy
      end
    end

    return true
  end
end
