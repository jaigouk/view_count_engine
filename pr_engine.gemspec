$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pr_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pr_engine"
  s.version     = PrEngine::VERSION
  s.authors     = ["jaigouk kim"]
  s.email       = ["jaigouk@gmail.com"]
  s.homepage    = "http://jaigouk.com"
  s.summary     = "PR"
  s.description = "View count + etc"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE.md", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.15"
  s.add_dependency "mongoid"
  s.add_dependency 'redis-objects'
  s.add_dependency "railties", "~> 3.2.15"
  s.add_dependency "sprockets-rails"
  s.add_dependency "geoip"
  s.add_dependency "httparty"
  s.add_dependency "coffee-script"
  s.add_dependency "browser"
  s.add_development_dependency "jquery-rails"
  s.add_development_dependency 'haml-rails'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'minitest-spec-rails'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'haml-rails'
  s.add_development_dependency "turn"
end
