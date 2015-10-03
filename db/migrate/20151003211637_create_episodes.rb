class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.integer :user_id
      t.integer :episode_id
      t.integer :series_id

      t.timestamps null: false
    end
  end
end
