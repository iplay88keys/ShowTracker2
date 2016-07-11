class AddPosterToSeries < ActiveRecord::Migration
  def self.up
    add_attachment :series, :poster
  end

  def self.down
    remove_attachment :series, :poster
  end
end
