require 'net/facebook/api/request'
require 'net/facebook/errors'

module Net
  module Facebook
    module Models
      class Page
        attr_reader :username, :likes

        def initialize(attrs = {})
          @username = attrs['username']
          @likes = attrs['likes']
        end


        # Returns the existing Facebook page matching the provided attributes or
        # nil when the page is not found.
        #
        # @return [Net::Facebook::Models::Page] the Facebook page.
        # @ return [nil] when the page cannot be found.
        # @param [Hash] params the attributes to find a page by.
        # @option params [String] :username The Facebook page’s username
        #   (case-insensitive).
        def self.find_by(params = {})
          find_by! params
        rescue Errors::UnknownUser
          nil
        end

        # Returns the existing Facebook page matching the provided attributes or
        # raises an error when the page is not found.
        #
        # @return [Net::Facebook::Models::Page] the Facebook page.
        # @param [Hash] params the attributes to find a page by.
        # @option params [String] :username The Facebook page’s username
        #   (case-insensitive).
        # @raise [Net::Errors::UnknownUser] if the page cannot be found.
        def self.find_by!(params = {})
          request = Api::Request.new params
          new request.run
        rescue Errors::ResponseError => error
          case error.response
            when Net::HTTPNotFound then raise Errors::UnknownUser
          end
        end
      end
    end
  end
end
