class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.integer :series_id
      t.string :name
      t.integer :season
      t.integer :season_id
      t.string :overview

      t.timestamps null: false
    end
  end
end
