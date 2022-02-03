module MultiTenancy
  module Console
    TenantMustBeSet = Class.new StandardError

    class << self
      def ask_for_tenant(can_skip: false)
        return if default_tenant

        hint = Paint["(press enter to skip)", :italic] if can_skip
        puts "\n#{Paint["Which tenant you want to connect to?", :bold]} #{hint}\n\n"
        list_tenants
        print "\n>_"
        tenant_from_choice(gets.chomp.to_i - 1) || no_tenant_chosen(can_skip)
      end

      def tenant_from_choice(index)
        return unless index.between?(0, Tenant.count - 1)

        Current.tenant = Tenant.all[index]
        Current.tenant.connect!
      end

      def list_tenants
        Tenant.each.with_index(1) do |tenant, index|
          puts "#{index} - #{Paint[tenant.ansi_colored_name, :bold]}"
        end
      end

      def no_tenant_chosen(can_skip)
        raise TenantMustBeSet, "You must choose a tenant" unless can_skip

        puts Paint["\n\tno connection set", :bold]
      end

      def default_tenant
        return unless ENV["DEV_DEFAULT_TENANT"].present?

        Current.tenant = Tenant.find_by_name(ENV["DEV_DEFAULT_TENANT"])
      end
    end
  end
end

Rails.application.console { MultiTenancy::Console.ask_for_tenant(can_skip: true) }
