class Tenant
  @all = []
  @by_hosts = {}

  class << self
    attr_reader :all, :by_hosts

    def register(tenant)
      all << tenant
      tenant.hosts.each do |host|
        by_hosts[host] = tenant
      end
    end

    ##
    # Needed by app/models/application_record.rb for `connects_to shards:`
    # Cf. https://guides.rubyonrails.org/v6.1/active_record_multiple_databases.html#horizontal-sharding
    #
    # {
    #   tenant_one: { writing: :tenant_one_db },
    #   tenant_two: { writing: :tenant_two_db }
    # }
    def connection_settings
      all.each_with_object({}) do |tenant, connections|
        connections[tenant.shard_name] = { writing: tenant.name }
      end
    end

    def find_by_host(host)
      by_hosts[host]
    end
  end

  attr_reader :name, :hosts, :db_url

  def initialize(name:, hosts:, db_url:)
    @name = name.to_sym
    @hosts = Array.wrap(hosts)
    @db_url = db_url

    self.class.register(self)
  end

  def shard_name
    "#{name}_shard".to_sym
  end

  def connection
    ActiveRecord::Base.connected_to(role: :writing, shard: shard_name) do
      yield
    end
  end
end
