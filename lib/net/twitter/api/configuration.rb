module Net
  module Twitter
    module Api
      class Configuration
        attr_accessor :apps

        def initialize
          @apps = []
          env_key = ENV['TWITTER_API_KEY']
          env_secret = ENV['TWITTER_API_SECRET']
          @apps.push key: env_key, secret: env_secret if env_key && env_secret
        end

        def key
          @apps.first[:key] if @apps.any?
        end

        def secret
          @apps.first[:secret] if @apps.any?
        end
      end
    end
  end
end
