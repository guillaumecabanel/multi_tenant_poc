class Tenant
  @all = []
  @by_hosts = {}
  @hooks ||= []
  @loaded = false

  class << self
    attr_reader :all

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

    def on_load(&block)
      return block.call if loaded?

      hooks << block
    end

    def loaded!
      hooks.each(&:call)

      self.loaded = true
    end

    private

    attr_reader :by_hosts, :hooks

    attr_writer :loaded

    def loaded?
      @loaded
    end

    def load_tenants!
      database_config = YAML.load(ERB.new(File.read(Rails.root.join("config", "database.yml"))).result)

      database_config[Rails.env].each do |name, tenant_config|
        Tenant.new(
          name: name,
          hosts: tenant_config["tenant_hosts"],
          db_url: tenant_config["url"]
        )
      end

      loaded!
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

  load_tenants!
end
