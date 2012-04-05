require 'uri'
require 'cgi'

module TokyoPI
  module Graphite
    class Graph < Configured
      def prepare!
        TokyoPI.log.debug "Fetching graph from url: #{url}"
        begin
          @config.image_store.add(url)
          @available = true
        rescue GraphiteException => ex
          TokyoPI.log.error "Couldn't add graph image to store: #{ex.inspect}"
          @available = false
        end
      end

      def url
        url_with_config_options
      end

      def available?
        @available
      end

      protected

      def setup(options, report = nil)
        super()
        @options = options
        @report  = report

        unless @options.length == 3
          raise GraphiteException.new("Expected a graph to be a 3-element array with the 3rd being the url. Found: #{@options.inspect}")
        end
        @url = @options[2]
        begin
          @path, @params = parse_url(@url)
        rescue Exception => ex
          TokyoPI.log.error "Couldn't parse URI for graph to extract params: #{@url}"
          raise GraphiteException.new(ex)
        end
      end

      def parse_url(url)
        uri = URI.parse(url)
        [uri.path, (CGI.parse(uri.query) rescue {})]
      end

      def url_with_config_options
        graph_options = @config['graphs'] || {}
        if @report && @report.report_config && @report.report_config['graphs']
          graph_options.merge!(@report.report_config['graphs'])
        end
        # Note: CGI.parse(query) returns all values as arrays, even if they're singular
        # However, the user configuration allows singular values for simplicity
        merged_params = @params.merge(graph_options).map do |key, value|
          if value.is_a? Enumerable
            value.map {|v| "#{key}=#{v}"}
          else
            "#{key}=#{value}"
          end
        end.flatten
        "#{@path}?#{merged_params.join('&')}"
      end
    end
  end
end
