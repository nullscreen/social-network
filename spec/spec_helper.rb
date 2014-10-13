require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
 SimpleCov::Formatter::HTMLFormatter,
 Coveralls::SimpleCov::Formatter
]
SimpleCov.start

Dir['./spec/support/**/*.rb'].each {|f| require f}

RSpec.configure do |config|
# config.order = 'random'
  config.before(:all) do
    Net::Twitter.configure do |config|
      if config.apps.empty?
        config.apps.push key: 'TWITTER_API_KEY', secret: 'TWITTER_API_SECRET'
      end
    end
  end
end