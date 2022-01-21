module TenantableJob
  def perform(...)
    tenant.connection { super }
  end
end
