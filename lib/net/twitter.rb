require 'net/twitter/config'
require 'net/twitter/errors'
require 'net/twitter/models'

module Net
  module Twitter
    extend Config
    include Errors
    include Models
  end
end