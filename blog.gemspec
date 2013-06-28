# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blog/version'

Gem::Specification.new do |spec|
  spec.name          = "blog"
  spec.version       = Blog::VERSION
  spec.summary       = "Earlydoc blog article models"
  spec.description   = "This gem provides the models and query logic for Earlydoc blog articles."
  spec.authors       = ['Earlydoc', 'Travis Dunn']
  spec.email         = 'developer@earlydoc.com'
  spec.homepage      = 'https://www.earlydoc.com'
  spec.license       = "MIT"
  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency 'mongoid', "~> 4.0"
  spec.add_dependency 'mongoid-pagination'
  spec.add_dependency 'mongoid-paperclip'
end
