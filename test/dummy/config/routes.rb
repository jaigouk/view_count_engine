Rails.application.routes.draw do

  get "home/foo"

  get "home/bar"

  get "home/baz"

  mount PrEngine::Engine => "/pr_engine"
  root to: "home#foo"
end
