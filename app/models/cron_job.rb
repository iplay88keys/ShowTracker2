class CronJob < ActiveRecord::Base
  def self.updateDatabase
    require "httparty"
    require "zip"

    # Get the contents of the remote zip file via HTTParty
    zipfile = Tempfile.new("file")
    zipfile.binmode # This might not be necessary depending on the zip file
    zipfile.write(HTTParty.get("http://thetvdb.com/api/" + Rails.application.secrets.tvdb_api_key + "/updates/updates_day.zip").body)
    zipfile.close

    # Unzip the temp zip file and process the contents
    Zip::File.open(zipfile.path) do |file|
    file.each do |content|
     data = file.read(content)
      end
    end
  end
end
