ActiveSupport.on_load(:active_record) do
  database_config = YAML.load(ERB.new(File.read(Rails.root.join("config", "database.yml"))).result)

  database_config[Rails.env].each do |name, tenant_config|
    Tenant.new(
      name: name,
      hosts: tenant_config["tenant_hosts"],
      db_url: tenant_config["url"]
    )
  end
end
