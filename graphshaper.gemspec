# -*- encoding: utf-8 -*-
require File.expand_path('../lib/graphshaper/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Lucas Dohmen"]
  gem.email         = ["me@moonglum.net"]
  gem.description   = %q{Generate realistic graphs}
  gem.summary       = %q{Graphshaper can generate realistic, scale-free graphs of any size for different databases.}
  gem.homepage      = "http://moonglum.github.com/graphshaper"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "graphshaper"
  gem.require_paths = ["lib"]
  gem.version       = Graphshaper::VERSION

  gem.add_dependency             "httparty", "~> 0.9.0"
  gem.add_development_dependency "rake",     "~> 0.9.3.beta.1"
  gem.add_development_dependency "rspec",    "~> 2.11.0"
  gem.add_development_dependency "webmock",  "~> 1.8.8"
  gem.add_development_dependency "yard",     "~> 0.8.2.1"
end
