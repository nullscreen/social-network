require 'net/facebook/errors/response_error'
require 'active_support'
require 'active_support/core_ext'

module Net
  module Facebook
    module Api
      class Request
        def initialize(attrs = {})
          @host = 'graph.facebook.com'
          @params = attrs[:params] if attrs[:params]
          @path = attrs.fetch :path, "/v2.3/#{@params}"
          @block = attrs.fetch :block, -> (request) {add_access_token! request}
          @method = attrs.fetch :method, :get
        end

        def run(options={})
          print "#{as_curl}\n"
          case response = run_http_request
          when Net::HTTPOK
            options[:auth] ? response.body : JSON.parse(response.body)
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
          @token ||= access_token
          @uri.request_uri << "?#{@token}"
        end

        def access_token
          @@access_token ||= fetch_access_token
        end

        def fetch_access_token
          path = '/oauth/access_token'
          block = -> (request) {add_client_credentials! request}
          request = Request.new path: path, method: :post, block: block
          authentication_data = request.run auth: true
        # rescue Errors::Suspended
        #   require 'pry'; binding.pry; true;
        end

        def add_client_credentials!(request)
          request.set_form_data client_id: Net::Facebook.configuration.client_id, client_secret: Net::Facebook.configuration.client_secret, grant_type: 'client_credentials'
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
