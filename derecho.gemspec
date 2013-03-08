# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'derecho/version'

Gem::Specification.new do |spec|
  spec.name          = 'derecho'
  spec.version       = Derecho::VERSION
  spec.date          = '2013-03-07'
  spec.authors       = ['Johnny Green']
  spec.email         = ['johnnygreen@gmail.com']
  spec.description   = 'Cloud automation help for the Rackspace Cloud + Chef + Beanstalkapp'
  spec.summary       = 'Derecho'
  spec.homepage      = 'http://github.com/mzwallace/derecho'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'thor', '0.17.0'
  spec.add_dependency 'fog', '1.10.0'

  spec.add_development_dependency 'bundler', '~>1.3'
  spec.add_development_dependency 'rake', '~>10.0.3'
  spec.add_development_dependency 'rspec', '~>2.13.0'
end
