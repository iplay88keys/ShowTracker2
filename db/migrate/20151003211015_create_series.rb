class CreateSeries < ActiveRecord::Migration
  def change
    create_table :series do |t|
      t.string :name
      t.string :overview
      t.string :status
      t.integer :last_updated

      t.timestamps null: false
    end
  end
end
