# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth-lumo/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Andrew Free"]
  gem.email         = ["andrew@schjelderup.org"]
  gem.description   = %q{OmniAuth strategy for iHealth.com.}
  gem.summary       = %q{OmniAuth strategy for iHealth.com.}
  gem.homepage      = "https://github.com/hspinks/omniauth-ihealth"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "omniauth-lumo"
  gem.require_paths = ["lib"]
  gem.version       = OmniAuth::Lumo::VERSION

  gem.add_dependency 'omniauth', '~> 1.0'
  gem.add_dependency 'omniauth-oauth2', '~> 1.0'
  gem.add_development_dependency 'rspec', '~> 2.7'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'webmock'
end