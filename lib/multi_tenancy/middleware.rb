module MultiTenancy
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      host = request.host
      Current.tenant = Tenant.find_by_host(host) if Tenant.known_host?(host)

      if Current.tenant
        Current.tenant.connection do
          return @app.call(env)
        end
      end

      return [200, {}, ["host not found"]]
    end
  end
end
