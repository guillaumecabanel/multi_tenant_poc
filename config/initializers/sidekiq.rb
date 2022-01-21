require 'sidekiq'
require 'sidekiq-status'
require 'sidekiq-scheduler'

Sidekiq.configure_client do |config|
  # accepts :expiration (optional)
  Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes

  config.redis = {
    url:             ENV['REDIS_URL'],
    network_timeout: 5
  }
end

Sidekiq.configure_server do |config|
  # accepts :expiration (optional)
  Sidekiq::Status.configure_server_middleware config, expiration: 30.minutes

  # accepts :expiration (optional)
  Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes

  config.redis = {url: ENV['REDIS_URL']}
  config.average_scheduled_poll_interval = 5
  config.on(:startup) do
    Sidekiq.schedule = YAML.load_file(File.join(Rails.root, 'config', 'scheduler.yml')) || {}
    SidekiqScheduler::Scheduler.instance.reload_schedule!

    Tenant.on_load do
      Tenant.each_connection do

      end
    end
  end
end
