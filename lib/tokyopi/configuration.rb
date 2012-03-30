require 'yaml'

module TokyoPI
  class Configuration
    attr_reader :config, :run_id

    def initialize(environment, filename = nil)
      @environment = environment
      @run_id = Time.now.strftime('%s')

      # Support loading a YAML file or directly from a hash
      if filename && filename.is_a?(Hash)
        @config = filename
        return
      end

      filename ||= File.join(File.dirname(__FILE__), '..', '..', 'config.yml')
      load_config(environment, filename)
    end

    def [](key)
      @config[key.to_s]
    end

    def merge!(keys)
      @config.merge!(keys)
    end

    def boot!
      TokyoPI.log = Logger.new(@config)
      TokyoPI.log.info("Booted TokyoPI in #{@environment} environment")
    end

    def path(relative_path)
      File.absolute_path(relative_path, File.join(File.dirname(__FILE__), '..', '..'))
    end

    def image_store
      @image_store ||= init_image_store
    end

    private

    def init_image_store
      method = @config['email']['image_display_method']
      case method
      when 'direct_link'
        Storage::NoopStore.new(self)
      when 's3'
        Storage::S3.new(self)
      else
        raise ConfigurationException.new("I don't know how to store images using '#{method}'")
      end
    end

    def load_config(environment, filename)
      begin
        yaml = YAML.load_file(filename)
      rescue Exception => ex
        STDERR.puts "Error loading configuration file #{filename}"
        raise ConfigurationException.new(ex)
      end
      @config = yaml[environment.to_s]
      if @config.nil?
        raise ConfigurationException.new("No such environment found in configuration file: #{environment}")
      end
    end
  end
end
