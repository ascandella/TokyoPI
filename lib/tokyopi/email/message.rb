require 'pony'

module TokyoPI
  module Email
    class Message < Configured

      def render
        @template = Template.new(@config)
        @result   = @template.render(@report)
      end

      def send
        TokyoPI.log.info "Sending report '#{@report.subject}' to #{@report.recipient}"
        Pony.mail(
          :to        => @report.recipient,
          :subject   => @report.subject,
          :html_body => @result
        )
      end

      protected

      def setup(report)
        @report = report

        Pony.options = {
          :from        => @config['mail']['from'],
          :via         => :smtp,
          :via_options => {
            :address => @config['mail']['server']
          }
        }
      end
    end
  end
end
