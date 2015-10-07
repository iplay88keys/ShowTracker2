class CronJob < ActiveRecord::Base
  def self.updateDatabase
    require "tvdbr"
    require "httparty"
    require "zip"
    require "nokogiri"

    # Get the contents of the remote zip file via HTTParty
    #zipfile = Tempfile.new("file")
    #zipfile.binmode # This might not be necessary depending on the zip file
    #zipfile.write(HTTParty.get("http://thetvdb.com/api/" + Rails.application.secrets.tvdb_api_key + "/updates/updates_day.zip").body)
    #zipfile.close

    # Unzip the temp zip file and process the contents
    #Zip::File.open(zipfile.path) do |file|
    Zip::File.open("updates_day.zip") do |zipfile|
      zipfile.each do |file|
        xml = Nokogiri::XML(zipfile.read(file))
        
        # Get series updates
        xml.xpath("/Data/Series").each do |series|
          id = series.children[0].text
          time = series.children[1].text
          element = Series.where(id: id).first
          if element != nil && element.last_updated < time
            client = Tvdbr::Client.new(Rails.application.secrets.tvdb_api_key)
            result = client.find_series_by_id(id)
            element.update_attributes(name: result.series_name, banner: result.banner ? result.banner : nil, banner_thumb: result.banner ? result.banner.gsub(/banners\//, "banners/_cache/") : nil, overview: result.overview == nil ? "" : result.overview, status: result.status, last_updated: result.lastupdated.to_i)
          end
        end
        
        # Get episode updates
        xml.xpath("/Data/Episode").each do |episode|
          id = episode.children[0].text
          time = episode.children[2].text
          element = Episodes.where(id: id).first
          if element != nil && element.last_updated < time
            client = Tvdbr::Client.new(Rails.application.secrets.tvdb_api_key)
            result = client.find_episode_by_id(id)
            element.update_attributes(name: result.series_name, banner: result.banner ? result.banner : nil, banner_thumb: result.banner ? result.banner.gsub(/banners\//, "banners/_cache/") : nil, overview: result.overview == nil ? "" : result.overview, status: result.status, last_updated: result.lastupdated.to_i)
          end
        end
        
        # Get banner updates
        xml.xpath("/Data/Banner").each do |banner|
          id = banner.children[0].text
          time = banner.children[3].text
          type = banner.children[4].text
          element = Series.where(id: id).first
          if element != nil && element.last_updated < time && type == "series"
            client = Tvdbr::Client.new(Rails.application.secrets.tvdb_api_key)
            result = client.find_series_by_id(id)
            element.update_attributes(banner: result.banner ? result.banner : nil, banner_thumb: result.banner ? result.banner.gsub(/banners\//, "banners/_cache/") : nil)
          end
        end
      end
    end
  end
end
