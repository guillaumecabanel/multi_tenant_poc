source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.3'

gem 'rails', '~> 6.1.4'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'

gem 'redis', '~> 4.0'
gem 'sidekiq', '6.2.1'
gem 'sidekiq-failures'
gem 'sidekiq-status'
gem 'sidekiq-scheduler'

gem 'bootsnap', '>= 1.4.4', require: false

gem "paint"

group :development, :test do
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  gem 'spring'
  gem 'pry-rails'
  gem 'pry-byebug', "~> 3.9"
  gem 'pry-doc'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
