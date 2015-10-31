class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.integer :series_id
      t.integer :episode_number
      t.string :name
      t.integer :season_number
      t.integer :season_id
      t.string :overview

      t.timestamps null: false
    end
  end
end
