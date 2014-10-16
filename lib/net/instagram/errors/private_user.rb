module Net
  module Instagram
    module Errors
      class PrivateUser < StandardError
        def message
          'Private user'
        end
      end
    end
  end
end
