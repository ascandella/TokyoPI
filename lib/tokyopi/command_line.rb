module TokyoPI
  class CommandLine
    def initialize
      # TODO
    end

    def load_config!(env = 'development', file = nil)
      @config = Configuration.new(env, file)
      # Load in any command line args
      @config.merge!({})
      @config.boot!
    end

    def prepare_report(name)
      @report = Report.new(@config, name)
    end

    def encode_report
      @report.encode
    end

    def send_report!
      @report.send!
    end

    def run_report(name)
      prepare_report(name) and encode_report and send_report!
    end
  end
end
