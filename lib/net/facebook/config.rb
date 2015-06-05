require 'net/facebook/api/configuration'

module Net
  module Facebook
    module Config
      def configure
        yield configuration if block_given?
      end

      def configuration
        @configuration ||= Api::Configuration.new
      end
    end
  end
end

