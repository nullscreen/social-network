module Net
  module Twitter
    module Errors
      class TooManyUsers < StandardError
        def message
          'Too many users in the request'
        end
      end
    end
  end
end