require 'httparty'

desc "Explaining what the task does"
task :download_geoip_data do

  geo_country_path = File.expand_path("../../geoip_db/#{Time.now.strftime("%m_%d_%Y")}_geo_country.dat.gz", __FILE__)
  geo_city_path = File.expand_path("../../geoip_db/#{Time.now.strftime("%m_%d_%Y")}_geo_city.dat.gz", __FILE__)
  geo_num_path =  File.expand_path("../../geoip_db/#{Time.now.strftime("%m_%d_%Y")}_geo_num.dat.gz", __FILE__)

  remote_info = [
    {path: geo_country_path, file: "http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz"},
    {path: geo_city_path, file: "http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz"},
    {path: geo_num_path, file: "http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz"}
  ]


  remote_info.each do |info|
    File.delete(info[:path]) if File.exist?(info[:path])
    File.delete(info[:path].gsub(".gz", "")) if File.exist?(info[:path].gsub(".gz", ""))
    File.open(info[:path], "wb") do |f|
      f.write HTTParty.get(info[:file]).parsed_response
    end
  end

  remote_info.each do |info|
    system(`gunzip #{info[:path]}`)
  end
end
