require 'net/facebook/api/request'
require 'net/facebook/errors'

module Net
  module Facebook
    module Models
      class User
        attr_reader :id, :email, :gender, :first_name, :last_name, :access_token

        def initialize(attrs = {})
          @id = attrs['id']
          @email = attrs['email']
          @gender = attrs['gender']
          @first_name = attrs['first_name']
          @last_name = attrs['last_name']
          @access_token = attrs['access_token']
        end

        def pages
          request = Api::Request.new access_token: @access_token, path: "/v2.3/#{@id}/accounts"
          page_json = request.run
          page_json['data'].map { |h| h.slice("name", "id") } if page_json['data'].any?
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
          find_by_username! params
        end

      private

        def self.find_by_username!(params = {})
          request = Api::Request.new username: params[:username], access_token: params[:access_token]
          if params[:access_token]
            new request.run.merge!({"access_token" => params[:access_token]})
          else
            new request.run
          end
        rescue Errors::ResponseError => error
          case error.response
            when Net::HTTPNotFound then raise Errors::UnknownUser
          end
        end
      end
    end
  end
end
