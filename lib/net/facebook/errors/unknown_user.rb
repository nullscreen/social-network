module Net
  module Facebook
    module Errors
      class UnknownUser < StandardError
        def message
          'Unknown user'
        end
      end
    end
  end
end
