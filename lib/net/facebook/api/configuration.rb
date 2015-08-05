module Net
  module Facebook
    module Api
      class Configuration
        attr_accessor :client_id, :client_secret

        def initialize
          @client_id = ENV['FACEBOOK_CLIENT_ID']
          @client_secret = ENV['FACEBOOK_CLIENT_SECRET']
        end
      end
    end
  end
end
