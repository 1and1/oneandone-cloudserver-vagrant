# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-oneandone/version'

Gem::Specification.new do |spec|
  spec.name          = 'vagrant-oneandone'
  spec.version       = VagrantPlugins::OneAndOne::VERSION
  spec.authors       = ['Nurfet Becirevic']
  spec.email         = ['nurfet@stackpointcloud.com']

  spec.description   = 'Enables Vagrant to manage 1&1 Cloud servers'
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/1and1/oneandone-cloudserver-vagrant'
  spec.license       = 'Apache-2.0'

  spec.add_runtime_dependency 'fog-oneandone', '>= 1.1'
  spec.add_runtime_dependency 'i18n', '>= 0.6.0'
  spec.add_runtime_dependency 'terminal-table', '~> 1.7.2'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'rubocop', '~> 0.39'
end
