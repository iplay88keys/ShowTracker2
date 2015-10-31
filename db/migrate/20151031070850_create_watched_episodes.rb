class CreateWatchedEpisodes < ActiveRecord::Migration
  def change
    create_table :watched_episodes do |t|
    t.integer :episode_id
    t.integer :user_id

    t.timestamps null: false
    end
  end
end
