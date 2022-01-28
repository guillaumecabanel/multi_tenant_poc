Rails.application.routes.draw do
  mount Sidekiq::Web => '/jobs'

  resources :posts

  root to: "posts#index", constraints: lambda { |request| Tenant.known_host? request.host }
  root to: "pages#unknown_host", as: :unknown_host
end
