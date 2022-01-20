class ApplicationController < ActionController::Base
  around_action :shard_swapping

  private

  def current_tenant
    @current_tenant ||= Tenant.find_by_host(request.host)
  end

  ##
  # Needed for Rails 6.1, if you have Rails 7+, see https://edgeguides.rubyonrails.org/active_record_multiple_databases.html#activating-automatic-shard-switching
  #
  # While Rails now supports an API for connecting to and swapping connections of shards,
  # it does not yet support an automatic swapping strategy. Any shard swapping will need
  # to be done manually in your app via a middleware or around_action.
  # Cf. https://guides.rubyonrails.org/v6.1/active_record_multiple_databases.html#automatic-swapping-for-horizontal-sharding
  #
  # Note:
  # The argument forwarding operator (`...`) needs ruby 2.7+
  def shard_swapping(...)
    current_tenant.connection(...)
  end
end
