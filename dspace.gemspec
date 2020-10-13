# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'dspace/version'

Gem::Specification.new do |spec|
  spec.name          = 'jrdspace'
  spec.version       = DSpace::VERSION
  spec.authors       = ['Monika Mevenkamp', 'Princeton University Library']
  spec.email         = ['dspadmin@princeton.edu']

  spec.summary       =  'JRuby classes that interact with the dspace-api Java classes - v5'
  spec.description   =  'jrdspace enables scripting of the dspace-api Java objects in a DSpace installation; it includes an interactive console'
  spec.homepage      = 'https://github.com/pulibrary/dspace-jruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency  'jar'
  spec.add_dependency  'json'

  spec.add_development_dependency 'bundler', '~> 2.1'
  # spec.add_development_dependency "rake", "~> 10.0"
end
