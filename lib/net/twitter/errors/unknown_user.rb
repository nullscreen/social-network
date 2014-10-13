module Net
  module Twitter
    module Errors
      class UnknownUser < StandardError
        def message
          'Unknown user'
        end
      end
    end
  end
end