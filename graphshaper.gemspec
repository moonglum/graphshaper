# -*- encoding: utf-8 -*-
require File.expand_path('../lib/graphshaper/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Lucas Dohmen"]
  gem.email         = ["me@moonglum.net"]
  gem.description   = %q{Graphshaper generates graphs for databases}
  gem.summary       = %q{Graphshaper can generate realistic, scale-free graphs of any size. The resulting graph can then be saved into different kinds of databases.}
  gem.homepage      = "http://github.com/moonglum/graphshaper"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "graphshaper"
  gem.require_paths = ["lib"]
  gem.version       = Graphshaper::VERSION
  
  gem.add_development_dependency 'rspec'
end
