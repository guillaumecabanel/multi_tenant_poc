Rails.logger.formatter = MultiTenancy::LogFormatter.new
ActionCable::Server::Base.prepend MultiTenancy::ActionCableServer
ActiveRecord::Base.singleton_class.prepend MultiTenancy::ActiveRecordConnection
