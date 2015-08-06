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

        # Returns the existing Facebook user matching the provided attributes or
        # nil when the user is not found.
        #
        # @return [Net::Facebook::Models::User] the Facebook user.
        # @ return [nil] when the user cannot be found.
        # @param [Hash] params the attributes to find a user by.
        # @option params [String] :username The Facebook user's username
        #   (case-insensitive).
        # @option params [String] :access_token The Facebook user's access_token
        #   (case-insensitive).
        def self.find_by(params = {})
          find_by! params
        rescue Errors::UnknownUser
          nil
        end

        # Returns the existing Facebook user matching the provided attributes or
        # raises an error when the user is not found.
        #
        # @return [Net::Facebook::Models::User] the Facebook user.
        # @param [Hash] params the attributes to find a user by.
        # @option params [String] :username The Facebook user's username
        #   (case-insensitive).
        # @option params [String] :access_token The Facebook user's access_token
        #   (case-insensitive).
        # @raise [Net::Errors::UnknownUser] if the user cannot be found.
        def self.find_by!(params = {})
          request = Api::Request.new params
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
