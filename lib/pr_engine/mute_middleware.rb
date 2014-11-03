module PrEngine
  class MuteMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      PrEngine.mute! { @app.call(env) }
    end
  end
end
