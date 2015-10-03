class CreateSeries < ActiveRecord::Migration
  def change
    create_table :series do |t|
      t.string :name
      t.string :banner
      t.string :overview
      t.string :status

      t.timestamps null: false
    end
  end
end
