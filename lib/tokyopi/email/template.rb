require 'erb'

module TokyoPI
  module Email
    class Template < Configured
      def render(report)
        template = load_template(report.template_name)
        template.result(report.get_binding)
      end

      private
      def load_template(path)
        template          = ERB.new(File.read(@config.path(path)))
        template.filename = path
        template
      end
    end
  end
end
