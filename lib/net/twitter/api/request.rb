require 'net/twitter/errors/response_error'
require 'active_support'
require 'active_support/core_ext'

module Net
  module Twitter
    module Api
      class Request
        def initialize(attrs = {})
          @host = 'api.twitter.com'
          @path = attrs.fetch :path, "/1.1/#{attrs[:endpoint]}.json"
          @query = attrs[:params].to_param if attrs[:params]
          @block = attrs.fetch :block, -> (request) {add_access_token! request}
          @method = attrs.fetch :method, :get
        end

        def run
          print "#{as_curl}\n"

          case response = run_http_request
          when Net::HTTPOK
            JSON response.body
          when Net::HTTPTooManyRequests
            store_rate_limit_reset response.header["x-rate-limit-reset"].to_i
            run
          else
            raise Errors::ResponseError, response
          end
        end

      private

        def run_http_request
          Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
            http.request http_request
          end
        end

        def http_request
          http_class = "Net::HTTP::#{@method.capitalize}".constantize
          @http_request ||= http_class.new(uri.request_uri).tap do |request|
            @block.call request
          end
        end

        def uri
          @uri ||= URI::HTTPS.build host: @host, path: @path, query: @query
        end

        def add_access_token!(request)
          request.add_field 'Authorization', "Bearer #{access_token}"
        end

        def access_token
          @@access_token ||= fetch_access_token
        end

        def fetch_access_token
          path = '/oauth2/token'
          block = -> (request) {add_client_credentials! request}
          request = Request.new path: path, method: :post, block: block
          authentication_data = request.run
          authentication_data['access_token']
        # rescue Errors::Suspended
        #   require 'pry'; binding.pry; true;
        end

        def add_client_credentials!(request)
          request.initialize_http_header client_credentials_headers
          request.add_field 'Authorization', "Basic #{credentials}"
          request.set_form_data grant_type: 'client_credentials'
        end

        def client_credentials_headers
          content_type = 'application/x-www-form-urlencoded;charset=UTF-8'
          {}.tap{|headers| headers['Content-Type'] = content_type}
        end

        def credentials
          @@app = apps.find(next_available_app) do |app|
            app[:limit_reset].to_i < Time.now.to_i
          end
          Base64.strict_encode64 "#{@@app[:key]}:#{@@app[:secret]}"
        end

        def next_available_app
          Proc.new do
            next_limit_reset = @@apps.map{|app| app[:limit_reset]}.min
            sleep_time = next_limit_reset - Time.now.to_i
            puts "Sleeping for #{sleep_time}s\n"
            sleep sleep_time
            puts "Waking up\n"
            @@apps.find{|app| app[:limit_reset] == next_limit_reset}
          end
        end

        def store_rate_limit_reset(limit_reset)
          @@app[:limit_reset] = limit_reset
          @@access_token, @@app, @http_request = nil, nil, nil
        end

        def apps
          @@apps ||= Net::Twitter.configuration.apps.map do |app|
            app.tap{app[:limit_reset] = nil}
          end
        end

        def as_curl
          'curl'.tap do |curl|
            curl <<  " -X #{http_request.method}"
            http_request.each_header do |name, value|
              curl << %Q{ -H "#{name}: #{value}"}
            end
            curl << %Q{ -d '#{http_request.body}'} if http_request.body
            curl << %Q{ "#{@uri.to_s}"}
          end
        end
      end
    end
  end
end
