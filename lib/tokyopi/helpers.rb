require 'date'

module TokyoPI
  module Helpers

    def img_url(graph)
      @config.image_store.fetch(graph.url)
    end

    def theme(key = nil)
      if key
        @config['email']['theme'][key]
      else
        @config['email']['theme']
      end
    end

    def substitute(str)
      str.gsub('$date', Date.today.to_s)
    end

  end
end
