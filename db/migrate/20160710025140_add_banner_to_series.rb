class AddBannerToSeries < ActiveRecord::Migration
  def self.up
    add_attachment :series, :banner
  end

  def self.down
    remove_attachment :series, :banner
  end
end
