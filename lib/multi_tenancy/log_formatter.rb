module MultiTenancy
  class LogFormatter < ::ActiveSupport::Logger::SimpleFormatter
    include ::ActiveSupport::TaggedLogging::Formatter

    def call(severity, timestamp, progname, msg)
      return super unless Current.tenant

      "[#{Current.tenant.ansi_colored_name(:bright)}] #{super}"
    end
  end
end
