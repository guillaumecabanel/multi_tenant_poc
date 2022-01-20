class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  connects_to shards: {
    tenant_one: { writing: :tenant_one },
    tenant_two: { writing: :tenant_two }
  }
end
