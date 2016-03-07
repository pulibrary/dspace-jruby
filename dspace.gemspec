# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dspace/version'

Gem::Specification.new do |spec|
  spec.name          = "jrdspace"
  spec.version       = DSpace::VERSION
  spec.authors       = ["Monika Mevenkamp"]
  spec.email         = ["monikam@princeton.edu"]

  spec.summary       =  %q{Jruby classes and utils that interact with the dspace-api Java classes - v5}
  spec.description   = %q{Documentation at github}
  spec.homepage      = "https://github.com/akinom/dspace-jruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency  'faker'
  spec.add_dependency  'json'
  spec.add_dependency  'highline'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
