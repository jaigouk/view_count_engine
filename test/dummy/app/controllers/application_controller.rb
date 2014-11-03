class ApplicationController < ActionController::Base
  protect_from_forgery
  helper PrEngine::Engine.helpers
end
