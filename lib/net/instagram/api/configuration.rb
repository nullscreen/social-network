module Net
  module Instagram
    module Api
      class Configuration
        attr_accessor :client_id

        def initialize
          @client_id = ENV['INSTAGRAM_CLIENT_ID']
        end
      end
    end
  end
end

