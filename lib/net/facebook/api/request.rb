require 'net/facebook/errors/response_error'
require 'active_support'
require 'active_support/core_ext'

module Net
  module Facebook
    module Api
      class Request
        def initialize(attrs = {})
          @host = 'graph.facebook.com'
          @query = attrs[:params] if attrs[:params]
          @path = attrs.fetch :path, "/v2.3/#{@query}"
          @method = attrs.fetch :method, :get
        end

        def run
          case response = run_http_request
          when Net::HTTPOK
            JSON.parse(response.body)
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
          @http_request ||= http_class.new(uri.request_uri)
        end

        def uri
          @uri ||= URI::HTTPS.build host: @host, path: @path, query: query
        end

        def query
          {}.tap do |query|
            query.merge! access_token: "#{Net::Facebook.configuration.client_id}|#{Net::Facebook.configuration.client_secret}"
          end.to_param
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
