require 'net/twitter/api/request'
require 'net/twitter/errors'

module Net
  module Twitter
    module Models
      class User
        attr_reader :screen_name, :follower_count

        def initialize(attrs = {})
          attrs.each{|k, v| instance_variable_set("@#{k}", v) unless v.nil?}
          @follower_count = attrs['followers_count']
        end

        # Returns the existing Twitter user matching the provided attributes or
        # nil when the user is not found.
        #
        # @return [Net::Twitter::Models::User] when the user is found.
        # @return [nil] when the user is not found or suspended.
        # @param [Hash] params the attributes to find a user by.
        # @option params [String] :screen_name The Twitter user’s screen name
        #   (case-insensitive).
        def self.find_by(params = {})
          find_by! params
        rescue Errors::UnknownUser, Errors::SuspendedUser
          nil
        end

        # Returns the existing Twitter user matching the provided attributes or
        # raises an error when the user is not found or suspended.
        #
        # @return [Net::Twitter::Models::User] the Twitter user.
        # @param [Hash] params the attributes to find a user by.
        # @option params [String] :screen_name The Twitter user’s screen name
        #   (case-insensitive).
        # @raise [Net::Errors::UnknownUser] if the user cannot be found.
        # @raise [Net::Errors::SuspendedUser] if the user account is suspended.
        def self.find_by!(params = {})
          request = Api::Request.new endpoint: 'users/show', params: params
          user_data = request.run
          new user_data
        rescue Errors::ResponseError => error
          case error.response
            when Net::HTTPNotFound then raise Errors::UnknownUser
            when Net::HTTPForbidden then raise Errors::SuspendedUser
          end
        end

        # Returns up to 100 existing Twitter users matching the provided
        # attributes. Raises an error when requesting more than 100 users.
        # Does not return users in the same order that they are requested.

        # @return [Array<Net::Twitter::Models::User>] the Twitter users.
        # @param [Hash] conditions The attributes to find users by.
        # @option conditions [Array<String>] screen_name The Twitter user's
        #   screen names (case-insensitive).
        # @raise [Net::Errors::TooManyUsers] when more than 100 Twitter users
        #   match the provided attributes.
        def self.where(conditions = {})
          params = to_where_params conditions
          request = Api::Request.new endpoint: 'users/lookup', params: params
          users_data = request.run
          users_data.map{|user_data| new user_data}
        rescue Errors::ResponseError => error
          case error.response
            when Net::HTTPNotFound then []
            when Net::HTTPForbidden then raise Errors::TooManyUsers
          end
        end

      private

        def self.to_where_params(conditions = {})
          conditions.dup.tap do |params|
            params.each{|k,v| params[k] = v.join(',') if v.is_a?(Array)}
          end
        end
      end
    end
  end
end
