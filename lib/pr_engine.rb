require "pr_engine/engine"
# http://api.rubyonrails.org/classes/ActiveSupport/Notifications.html
module PrEngine
  PRENGINE_ROOT = File.join(File.dirname(__FILE__))
  UPDATED_GEO_AT = "10_02_2013"
end

require "pr_engine/csv_streamer"
