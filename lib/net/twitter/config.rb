require 'net/twitter/api/configuration'

module Net
  module Twitter
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