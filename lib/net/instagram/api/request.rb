require 'net/instagram/errors/response_error'
require 'net/instagram/errors/unknown_user'
require 'active_support'
require 'active_support/core_ext'

module Net
  module Instagram
    module Api
      class Request
        def initialize(attrs = {})
          @host = 'api.instagram.com'
          @path = attrs.fetch :path, "/v1/#{attrs[:endpoint]}"
          @query = attrs[:params] if attrs[:params]
          @method = attrs.fetch :method, :get
        end

        def run
          case response = run_http_request
          when Net::HTTPOK
            JSON(response.body)['data']
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
            query.merge! @query if @query
            query.merge! client_id: Net::Instagram.configuration.client_id
          end.to_param
        end
      end
    end
  end
end
