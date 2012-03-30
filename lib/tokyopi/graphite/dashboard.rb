require 'uri'
require 'json'

module TokyoPI
  module Graphite
    class Dashboard < GraphiteJsonClient
      attr_reader :graphs, :name

      def fetch_config
        connect unless @connected
        begin
          dash_json = get("/dashboard/load/#{URI.escape(@name)}").body
        rescue SocketError => ex
          TokyoPI.log.fatal "Couldn't connect to graphite over HTTP. Perhaps the host is down?"
          raise GraphiteException.new(ex)
        rescue Faraday::Error::ClientError => ex
          TokyoPI.log.fatal "Couldn't load dashboard '#{@name}', encountered HTTP exception: #{ex.inspect}"
          raise GraphiteException.new(ex)
        end

        dash_config = dash_json['state']
        if dash_config.nil?
          raise GraphiteException.new "No key 'state' found in dashboard json: #{dash_json.inspect}"
        end

        @graphs = parse_graphs dash_config['graphs']
        TokyoPI.log.info "Loaded dashboard: '#{@name}'"

        @fetched = true
      end

      def fetch_graphs!
        connect unless @connected
        fetch_config unless @fetched
        if @graphs.nil? || @graphs.length == 0
          TokyoPI.log.warn "No graphs fetched for dashboard '#{@name}'"
        else
          @graphs.each { |graph| graph.prepare! }
        end
      end

      def parse_graphs(graphs)
        graphs.map { |graph| Graph.new(@config, graph, @report) } if graphs
      end

      def href
        "#{host}/dashboard/#{URI.escape(@name)}"
      end

      protected

      def setup(name, report = nil)
        super()
        @name = name
        @report = report
      end
    end
  end
end
