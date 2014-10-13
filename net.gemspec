# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'net/version'

Gem::Specification.new do |spec|
  spec.name          = "net"
  spec.version       = Net::VERSION
  spec.authors       = ["Jeremy Cohen Hoffing", "Claudio Baccigalupo"]
  spec.email         = ["jcohenhoffing@gmail.com", "claudio@fullscreen.net"]
  spec.summary       = %q{An API Client for social networks}
  spec.description   = %q{Retrieves information for Twitter users}
  spec.homepage      = "https://github.com/Fullscreen/net"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport' 
  
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.3"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "yard", "~> 0.8.7"
  spec.add_development_dependency "coveralls", "~> 0.7.1"
  spec.add_development_dependency "vcr", "~> 2.9"
  spec.add_development_dependency "webmock", "~> 1.19"
end