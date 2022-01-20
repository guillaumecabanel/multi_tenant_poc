class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  connects_to shards: Tenant.connection_settings
end
