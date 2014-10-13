module Net
  module Twitter
    module Errors
      class SuspendedUser < StandardError
        def message
          'Suspended user'
        end
      end
    end
  end
end