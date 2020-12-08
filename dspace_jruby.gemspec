# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'dspace/version'

Gem::Specification.new do |spec|
  spec.name          = 'dspace-jruby'
  spec.version       = DSpace::VERSION
  spec.authors       = ['Monika Mevenkamp', 'Princeton University Library']
  spec.email         = ['dspadmin@princeton.edu']

  spec.summary       =  'JRuby API which interacts with the DSpace API Java classes'
  spec.description   =  'dspace-jruby enables scripting of the dspace-api Java objects in a DSpace installation'
  spec.homepage      = 'https://github.com/pulibrary/dspace-jruby'
  spec.license       = 'MIT'

  spec.required_ruby_version = '~> 2.5'
  spec.platform = Gem::Platform.local

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency  'json'

  spec.add_development_dependency 'bundler', '~> 2.1'
end
