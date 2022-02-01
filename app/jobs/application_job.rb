class ApplicationJob < ActiveJob::Base
  include MultiTenancy::TenantableJob
end
