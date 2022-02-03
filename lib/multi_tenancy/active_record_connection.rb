module MultiTenancy
  module ActiveRecordConnection
    def connection
      return super if Current.tenant

      raise Tenant::TenantMustBeSet, "You must set a tenant before querying"

    rescue Tenant::TenantMustBeSet => e
      STDERR.puts "\nfrom #{caller.second}\n\n"

      raise
    end
  end
end
