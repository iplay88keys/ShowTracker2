class CreateWatches < ActiveRecord::Migration
  def change
    create_table :watches do |t|
      t.integer :episode_id
      t.integer :user_id
      t.integer :series_id
      t.integer :season_id

      t.timestamps null: false
    end
  end
end
