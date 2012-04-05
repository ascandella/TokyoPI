require 'aws/s3'

module TokyoPI
  module Storage
    class S3 < ImageStore
      protected

      def setup
        super()
        @bucket = @config['s3']['bucket']

        AWS::S3::Base.establish_connection!(
          :access_key_id => @config['s3']['access_key'],
          :secret_access_key => @config['s3']['secret_access_key']
        )
      end

      def store(url)
        connect unless @connected
        begin
          data = get(url).body
        rescue => ex
          TokyoPI.log.error "Error storing image to S3: #{ex.inspect}"
          TokyoPI.log.error "Here's the backtrace: #{ex.backtrace.join("\n")}"
          raise GraphiteException.new(ex)
        end
        unique_url = "images/graphs/#{@config.run_id}/#{key(url)}.png"
        AWS::S3::S3Object.store(unique_url, data, @bucket, :access => :public_read)
        AWS::S3::S3Object.url_for(unique_url, @bucket,
          :expires_in => 60 * 60 * 24 * @config['s3']['expire_days'].to_i)
      end
    end
  end
end
