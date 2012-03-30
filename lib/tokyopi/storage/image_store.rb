require 'digest/md5'

module TokyoPI
  module Storage
    class ImageStore < Graphite::GraphiteClient

      def add(url)
        hash_key = key(url)
        if @images[hash_key]
          TokyoPI.log.warn("Already have an image registered for url: #{url}. Overwriting")
        end
        @images[hash_key] = store(url)
      end

      def fetch(url)
        stored_url = @images[key(url)]
        if stored_url.nil?
          raise OhSnapException.new "Don't have a graph registered for that URL: #{url}"
        else
          stored_url
        end
      end

      protected

      def store(url)
        raise NotImplementedError.new("Need to subclass ImageStore")
      end

      def key(url)
        Digest::MD5.hexdigest(url)
      end

      def setup
        super()
        @images = {}
      end

    end

    class NoopStore < ImageStore
      protected
      def store(url)
        "#{host}/#{url}"
      end
    end
  end
end
