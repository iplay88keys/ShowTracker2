class CreateLsts < ActiveRecord::Migration
  def change
    create_table :lsts do |t|
      t.integer :user_id
      t.integer :series_id
      t.boolean :completed

      t.timestamps null: false
    end
  end
end
