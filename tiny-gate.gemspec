# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tiny_gate/version'

Gem::Specification.new do |spec|
  spec.name          = 'tiny-gate'
  spec.version       = TinyGate::VERSION
  spec.authors       = ['TINYpulse']
  spec.email         = ['devops@tinypulse.com']

  spec.summary       = %q{An authentication client for all TINYpulse apps}
  spec.description   = %q{This is an authentication client for all TINYpulse apps which use single sign on.}
  spec.homepage      = 'https://github.com/TINYhr/tiny-gate'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'dry-configurable'
  spec.add_dependency 'dry-struct', '~> 0.5', '>= 0.5.0'
  spec.add_dependency 'http'
  spec.add_dependency 'sinatra'
  spec.add_dependency 'daemons'

  spec.add_development_dependency 'bundler',   '~> 1.12'
  spec.add_development_dependency 'rake',      '~> 10.0'
  spec.add_development_dependency 'rspec',     '~> 3.0'
  spec.add_development_dependency 'rack-test', '~> 0.6.3'
end
