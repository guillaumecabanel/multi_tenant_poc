Rails.application.routes.draw do
  mount Sidekiq::Web => '/jobs'

  resources :posts

  root to: "posts#index", constraints: lambda { |request| Tenant.hosts.include? request.host }
  root to: "pages#unknown_host", as: :unknown_host
end
