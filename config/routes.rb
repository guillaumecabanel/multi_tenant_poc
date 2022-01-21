Rails.application.routes.draw do
  mount Sidekiq::Web => '/jobs'

  resources :posts
  root to: "posts#index"
end
