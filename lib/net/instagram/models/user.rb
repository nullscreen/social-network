require 'net/instagram/api/request'
require 'net/instagram/errors'

module Net
  module Instagram
    module Models
      class User
        attr_reader :username, :follower_count

        def initialize(attrs = {})
          @username = attrs['username']
          @follower_count = attrs['counts']['followed_by']
        end

        # Returns the existing Instagram user matching the provided attributes or
        # nil when the user is not found.
        #
        # @return [Net::Instagram::Models::User] when the user is found.
        # @return [nil] when the user is not found or has a private account.
        # @param [Hash] params the attributes to find a user by.
        # @option params [String] :username The Instagram user’s username
        #   (case-insensitive).
        def self.find_by(params = {})
          find_by! params
        rescue Errors::PrivateUser, Errors::UnknownUser
          nil
        end

        # Returns the existing Instagram user matching the provided attributes or
        # nil when the user is not found, and raises an error when the user account is private.
        #
        # @return [Net::Instagram::Models::User] the Instagram user.
        # @param [Hash] params the attributes to find a user by.
        # @option params [String] :username The Instagram user’s username
        #   (case-insensitive).
        # @option params [String] :id The Instagram user’s id
        #   (case-insensitive).
        # @raise [Net::Errors::PrivateUser] if the user account is private.
        def self.find_by!(params = {})
          if params[:username]
            find_by_username! params[:username]
          elsif params[:id]
            find_by_id! params[:id]
          end
        end

      private

        def self.find_by_username!(username)
          request = Api::Request.new endpoint: "users/search", params: {q: username}
          users = Array.wrap request.run
          if user = users.find{|u| u['username'].casecmp(username).zero?}
            find_by_id! user['id']
          else
            raise Errors::UnknownUser
          end
        end

        def self.find_by_id!(id)
          request = Api::Request.new endpoint: "users/#{id}"
          new request.run
        rescue Errors::ResponseError => error
          case error.response
            when Net::HTTPBadRequest then raise Errors::PrivateUser
          end
        end
      end
    end
  end
end
