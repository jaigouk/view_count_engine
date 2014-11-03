PrEngine::Engine.routes.draw do
  root to: "metrics#index"
  resources :metrics, only: [:index, :destroy]
   post '/update_view_count/:klass/:id' => 'view_count#update_view_count', as: :update_view_count
end
