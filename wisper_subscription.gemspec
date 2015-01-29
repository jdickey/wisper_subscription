
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wisper_subscription/version'

Gem::Specification.new do |spec|
  spec.name          = "wisper_subscription"
  spec.version       = WisperSubscription::VERSION
  spec.authors       = ["Jeff Dickey"]
  spec.email         = ["jdickey@seven-sigma.com"]
  spec.summary       = %q{Records and reports messages sent using Wisper conventions.}
  spec.homepage      = "https://github.com/jdickey/wisper_subscription"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  spec.add_development_dependency 'rubocop', '>= 0.28.0'
  spec.add_development_dependency 'simplecov', '>= 0.9.1'
  # spec.add_development_dependency 'awesome_print'
  # spec.add_development_dependency 'pry-byebug'
  # spec.add_development_dependency 'pry-doc'

  spec.description   = %q{May be used to subscribe to Wisper broadcasts, or other
similar mechanisms. Define what messages you want an instance to respond to and,
when those messages are received, any parameters or "payload" associated with
each single message is saved for later querying and retrieval. See the README for
more information.}
end
