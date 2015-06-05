require 'net/facebook/config'
require 'net/facebook/models'
require 'net/facebook/errors'

module Net
  module Facebook
    extend Config
    include Errors
    include Models
  end
end
