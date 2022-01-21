class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

  def self.inherited(base)
    base.prepend TenantableJob
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
