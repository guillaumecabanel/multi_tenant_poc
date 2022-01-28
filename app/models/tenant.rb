class Tenant
  class TenantNotFound < ActiveRecord::RecordNotFound; end;

  @all = []
  @by_hosts = {}
  @by_names = {}.with_indifferent_access
  @hooks ||= []
  @loaded = false

  class << self
    include Enumerable

    delegate :each, to: :all

    attr_reader :all

    def register(tenant)
      all << tenant

      by_names[tenant.name] = tenant

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
      by_hosts[host] || raise(TenantNotFound, "Tenant not found for #{host}")
    end

    def find_by_name(name)
      by_names[name] || raise(TenantNotFound, "Tenant not found for #{name}")
    end

    ##
    # Register hooks if class is not yet loaded, for them to be called when tenants are loaded (see `::loaded!`).
    def on_load(&block)
      return block.call if loaded?

      hooks << block
    end

    def loaded!
      hooks.each(&:call)

      self.loaded = true
    end

    ##
    # Temporary set the Current.tenant to each tenant
    # to perform jobs with the correct tenant, for example.
    def each_connection(&block)
      each do |tenant|
        Current.set(tenant: tenant) do
          tenant.connection(&block)
        end
      end
    end

    def hosts
      all.flat_map(&:hosts)
    end

    private

    attr_reader :by_hosts, :by_names, :hooks

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

      # We need to have an explicit tenant before performing ActiveRecord actions.
      ActiveRecord::Base.default_shard = nil

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

  ##
  # https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-connected_to
  def connection
    ActiveRecord::Base.connected_to(role: :writing, shard: shard_name) do
      Current.set(tenant: self) do
        yield
      end
    end
  end

  def set_as_default_connection!
    Current.tenant = self
    ActiveRecord::Base.default_shard = shard_name

    Rails.logger.info "Connected to `#{Current.tenant.name}`!"
  end

  load_tenants!
end
