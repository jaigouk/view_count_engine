require "mongoid"
require "pr_engine/engine"
module PrEngine
  class VisitedBrowser
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name, type: String
    field :version, type: String
    field :mobile, type: Boolean, default: false

    belongs_to :view_count
    validates_presence_of :name
  end
end
