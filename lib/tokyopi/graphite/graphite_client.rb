require 'json/ext'
require 'forwardable'
require 'faraday'
require 'faraday_middleware'
# ARGH, Faraday middleware can't handle both JSON and non-JSON requests
require 'net/http'

module TokyoPI
  module Graphite
    class GraphiteClient < Configured
      extend Forwardable
      def_delegator :@faraday, :get

      def connect
        @faraday = Faraday.new(:url => host) do |builder|
          builder.adapter Faraday.default_adapter
          build(builder) if self.respond_to?(:build)
        end
        @connected = true
        TokyoPI.log.debug "Initialized Farady connection to #{host}"
      end

      protected
      def host
        "http://#{@config['graphite']['host']}"
      end
    end

    class GraphiteJsonClient < GraphiteClient
      def build(builder)
        builder.use FaradayMiddleware::ParseJson
      end
    end
  end
end
