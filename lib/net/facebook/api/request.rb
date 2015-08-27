require 'net/facebook/errors/response_error'
require 'active_support'
require 'active_support/core_ext'

module Net
  module Facebook
    module Api
      class Request
        def initialize(attrs = {})
          @host = 'graph.facebook.com'
          @query = attrs[:username] if attrs[:username]
          @access_token = attrs[:access_token] if attrs[:access_token]
          @path = attrs.fetch :path, "/v2.3/#{@query}"
          @method = attrs.fetch :method, :get
        end

        def run
          print "#{as_curl}\n"
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
          query = @access_token ? facebook_access_token : facebook_app_keys
          @uri ||= URI::HTTPS.build host: @host, path: @path, query: query
        end

        def facebook_app_keys
          {}.tap do |query|
            query.merge! access_token: "#{Net::Facebook.configuration.client_id}|#{Net::Facebook.configuration.client_secret}"
          end.to_param
        end

        def facebook_access_token
          {}.tap do |query|
            query.merge! access_token: @access_token
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
