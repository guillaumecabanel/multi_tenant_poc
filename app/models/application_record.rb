class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  connects_to shards: {
    tenant_one: { writing: :tenant_one, reading: :tenant_one_replica },
    tenant_two: { writing: :tenant_two, reading: :tenant_two_replica }
  }
end
