Rails.logger.formatter = MultiTenancy::LogFormatter.new
ActionCable::Server::Base.prepend MultiTenancy::ActionCableServer
