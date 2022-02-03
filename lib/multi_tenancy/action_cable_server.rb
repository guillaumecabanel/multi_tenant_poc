module MultiTenancy
  module ActionCableServer
    def broadcast(broadcasting, message, coder: ActiveSupport::JSON)
      super(Tenant.channel_for(broadcasting), message, coder: coder)
    end
  end
end
