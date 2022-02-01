class ApplicationController < ActionController::Base
  ##
  # Needed for Rails 6.1, if you have Rails 7+, see https://edgeguides.rubyonrails.org/active_record_multiple_databases.html#activating-automatic-shard-switching
  #
  # While Rails now supports an API for connecting to and swapping connections of shards,
  # it does not yet support an automatic swapping strategy. Any shard swapping will need
  # to be done manually in your app via a middleware or around_action.
  # Cf. https://guides.rubyonrails.org/v6.1/active_record_multiple_databases.html#automatic-swapping-for-horizontal-sharding
  #
end
