module TenantableJob
  extend ActiveSupport::Concern

  module JobInstance
    def perform(...)
      tenant.connection { super }
    end
  end

  class_methods do
    def inherited(base)
      base.prepend JobInstance
    end
  end

  attr_accessor :tenant

  def initialize(...)
    super
    @tenant = Current.tenant
  end

  def serialize
    super.merge('tenant_name' => tenant.name)
  end

  def deserialize(job_data)
    super
    self.tenant = Tenant.find_by_name job_data['tenant_name']
  end
end
