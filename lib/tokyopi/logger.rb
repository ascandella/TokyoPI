require 'logger'
require 'forwardable'

module TokyoPI
  class Logger < Configured
    extend Forwardable
    def_delegators :@logger, :debug, :info, :warn, :error, :fatal

    def setup
      if @config
        destination   = (@config['log'].nil? || @config['debug']) ? STDOUT : @config['log']
        @logger       = ::Logger.new(destination)
        @logger.level = ::Logger.const_get(@config['log_level'].upcase)
      end
    end
  end

  class << self
    attr_accessor :log
  end
end
