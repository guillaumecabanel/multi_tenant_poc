module SetCurrentTenant
  extend ActiveSupport::Concern

  included do
    before_action do
      Current.tenant = Tenant.find_by_host(request.host)
    end
  end
end
