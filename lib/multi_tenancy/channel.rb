module MultiTenancy
  module Channel
    def tenant
      Tenant.find_by_host(host)
    end

    def host
      Rack::Request.new(connection.env).host
    end

    def stream_from(broadcasting)
      super tenant.channel_for(broadcasting)
    end

    def stream_for(*)
      raise NotImplemented, "stream_for with MultiTenancy is not yet supported"
    end
  end
end
