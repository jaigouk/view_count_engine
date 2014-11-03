# 2.0.0-p0 :004 > PrEngine::Metric.last
# => #<PrEngine::Metric _id: 52471dd3c342d1ba7e000003, name: "process_action.action_controller", duration: 8140, instrumenter_id: "6f6fc2096ba82d47848a", payload: {"controller"=>"HomeController", "action"=>"foo", "params"=>{"controller"=>"home", "action"=>"foo"}, "format"=>:html, "method"=>"GET", "path"=>"/home/foo", "status"=>200, "view_runtime"=>7.702}, started_at: 2013-09-28 18:20:03 UTC, created_at: 2013-09-28 18:20:03 UTC>
module PrEngine
  class Metric
    include Mongoid::Document

    field :name, type: String
    field :duration, type: Integer
    field :instrumenter_id, type: String
    field :payload, type: Hash
    field :controller, type: String
    field :action, type: String
    field :path, type: String
    field :started_at, type: DateTime
    field :created_at, type: DateTime

    def self.store!(args)
      metric = new

      # metric.parse(args)

      # metric.save!
    end

    require "csv"

    def to_csv
      [controller, action, path, started_at, duration, created_at].to_csv
    end

    def parse(args)
      # args is an array with five items:

      # • name: A String with the name of the event
      # • started_at: A Time object representing when the event started
      # • ended_at: A Time object representing when the event ended
      # • instrumenter_id: A String containing the unique ID of the object instrumenting the event
      # • payload: A Hash with the information given as payload to the instrument() method

      self.name = args[0]
      self.started_at = args[1]
      self.duration = (args[2] - args[1]) * 1000000
      self.instrumenter_id = args[3]
      self.payload = args[4]
      self.created_at = Time.now.utc
      self.controller = self.payload[:params][:controller]
      self.action = self.payload[:params][:path]
      self.path = self.payload[:params][:path]
    end
  end
end
