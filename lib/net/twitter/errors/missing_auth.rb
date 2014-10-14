module Net
  module Twitter
    module Errors
      class MissingAuth < StandardError
        def message
          'Missing credentials'
        end
      end
    end
  end
end

