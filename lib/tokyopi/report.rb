module TokyoPI
  class Report < Configured
    include Helpers
    attr_accessor :dashboards
    attr_reader :report_config

    def encode
      if @dashboards.nil? || @dashboards.length < 1
        TokyoPI.log.error "No dashboards configured for report. Nothing to encode."
      else
        @dashboards.each {|dash| dash.fetch_graphs!}
      end

      @message = Email::Message.new(@config, self)
    end

    def send!
      @message.render
      @message.send
    end

    def template_name
      default_value('template', 'default_template')
    end

    def recipient
      default_value('recipient')
    end

    def get_binding
      binding
    end

    def subject
      substitute(@report_config['name'])
    end

    def heading
      if @report_config['heading']
        substitute(@report_config['heading'])
      else
        subject
      end
    end

    protected

    def default_value(key, default_key = nil)
      return @report_config[key] unless @report_config[key].nil?
      @config[default_key || key]
    end

    def setup(name)
      @name = name

      @report_config = @config['reports'][@name]
      if @report_config.nil?
        TokyoPI.log.error "No  report found in configuration: #{@name}"
        raise ConfigurationException.new "Misconfiguration in report #{@name}, check logs"
      elsif @report_config['dashboards'].nil? || @report_config['dashboards'].empty?
        TokyoPI.log.error "No dashboards defined for report: #{@name}"
        TokyoPI.log.error "Here's the configuration: #{@report_config.inspect}"
        raise ConfigurationException.new "Missing dashboards. Check logs."
      end

      @dashboards = @report_config['dashboards'].map do |dash|
        Graphite::Dashboard.new(@config, dash, self)
      end

      TokyoPI.log.info "Successfully initialized #{@dashboards.length} dashboard(s) for report '#{@name}'"
    end
  end
end
