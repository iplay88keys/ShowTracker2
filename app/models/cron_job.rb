class CronJob < ActiveRecord::Base
  def self.updateDatabase
    #http://thetvdb.com/api/" + "/mirrors.xml"
    #wget "http://www.tvdb.com/api/" + Rails.application.secrets.tvdb_api_key + "updates/updates_day.zip"
  end
end
