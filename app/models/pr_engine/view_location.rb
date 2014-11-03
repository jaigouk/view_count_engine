require "mongoid"
require 'geoip'
# https://github.com/nofxx/mongoid_geospatial
require 'mongoid_geospatial'
require "pr_engine/engine"
module PrEngine
  class ViewLocation
    GEO_COUNTRY_DAT = File.join(PrEngine::PRENGINE_ROOT, "geoip_db/#{PrEngine::UPDATED_GEO_AT}_geo_country.dat")
    GEO_CITY_DAT = File.join(PrEngine::PRENGINE_ROOT, "geoip_db/#{PrEngine::UPDATED_GEO_AT}_geo_city.dat")
    GEO_NUM_DAT =  File.join(PrEngine::PRENGINE_ROOT, "geoip_db/#{PrEngine::UPDATED_GEO_AT}_geo_num.dat.gz")

    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Geospatial

    geo_field :coordinates
    spatial_scope :coordinates

    field :ip
    field :country_code2
    field :country_code3
    field :country_name
    field :city_name
    field :postal_code
    field :timezone
    field :real_region_name
    field :dma_code
    field :area_code

    belongs_to :view_count
    validates_presence_of :ip
    after_create :geocode_it

    def geocode_it
      begin
        c = GeoIP.new(GEO_CITY_DAT).city(self.ip)
        self.country_code2 = c[:country_code2]
        self.country_code3 = c[:country_code3]
        self.country_name = c[:country_name]
        self.city_name = c[:city_name]
        self.postal_code = c[:postal_code]
        self.timezone = c[:timezone]
        self.dma_code = c[:dma_code]
        self.area_code = c[:area_code]
        self.real_region_name = c[:real_region_name]
        self.coordinates = {:latitude => c[:latitude], :longitude => c[:longitude]}
        self.save
      rescue
        puts "failed to find the location by ip #{self.ip} at #{Time.now}"
      end
    end

    def self.near_from(lat, lng, max_distance = 1)
      # maxDistance number  Optional. A distance from the center point. Specify the distance in meters for GeoJSON data and in radians for legacy coordinate pairs. MongoDB limits the results to those documents that fall within the specified distance from the center point. http://docs.mongodb.org/manual/reference/command/geoNear/#dbcmd.geoNear
      # gem uses mile.
      # In this engine, we treat max_distance as km
      self.near(coordinates: [lat, lng]).max_distance(coordinates: max_distance * 1.6)
    end

  end
end
