class ApplicationController < ActionController::Base
  around_action :select_tenant

  private

  def select_tenant
    ActiveRecord::Base.connected_to(role: :writing, shard: TENANT_HOSTS[request.host]) do
      yield
    end
  end
end
