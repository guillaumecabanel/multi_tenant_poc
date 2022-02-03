# Usage

```ruby
# Gemfile

gem 'paint'
```

```yaml
# config/database.yml

development:
  tenant_one:
    database: my_application_development
    tenant_hosts:
      - localhost
  tenant_two:
    database: my_application_development_tenant_two
    tenant_hosts:
      - 127.0.0.1
```

```ruby
# config/application.rb

# [...]
module MyApplication
  class Application < Rails::Application
    # [...]
    require "multi_tenancy"
    config.middleware.use MultiTenancy::Middleware
  end
end
```

```ruby
# should be prefixed with 0 to make sure the initializer is the first executed
# (to prevent unwanted connections in later initializers)
# config/initializers/0_multi_tenancy.rb

Rails.logger.formatter = MultiTenancy::LogFormatter.new
ActionCable::Server::Base.prepend MultiTenancy::ActionCableServer
ActiveRecord::Base.singleton_class.prepend MultiTenancy::ActiveRecordConnection
```

```ruby
# app/jobs/application_job.rb

class ApplicationJob < ActiveJob::Base
  include Sidekiq::Status::Worker
  include MultiTenancy::TenantableJob
end
```

```ruby
# app/channels/application_cable/channel.rb

module ApplicationCable
  class Channel < ActionCable::Channel::Base
    prepend MultiTenancy::Channel
  end
end
```

```ruby
# db/seeds.rb

# before everything:
MultiTenancy::Console.ask_for_tenant
# [...]
```

```ruby
# app/models/current.rb

class Current < ActiveSupport::CurrentAttributes
  # [...]
  attribute :tenant
end
```
