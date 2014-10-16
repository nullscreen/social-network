require 'net/instagram/api/configuration'

module Net
  module Instagram
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

