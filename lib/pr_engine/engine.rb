# require "pr_engine/mute_middleware"

module PrEngine
  class Engine < ::Rails::Engine
    isolate_namespace PrEngine
    # config.middleware.use MuteMiddleware
    # config.to_prepare do
    #   PrEngine::ApplicationController.helper Rails.application.helpers
    # end
  end
end
