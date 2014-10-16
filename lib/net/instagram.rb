require 'net/instagram/config'
require 'net/instagram/models'

module Net
  module Instagram
    extend Config
    include Errors
    include Models
  end
end
