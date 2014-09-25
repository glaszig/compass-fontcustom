# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'compass/fontcustom/version'

Gem::Specification.new do |spec|
  spec.name          = "compass-fontcustom"
  spec.version       = Compass::Fontcustom::VERSION
  spec.authors       = ["glaszig"]
  spec.email         = ["glaszig@gmail.com"]
  spec.description   = %q{Fontcustom for Compass}
  spec.summary       = %q{Integrates Fontcustom with Compass}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/).reject { |f| f =~ /^(demo|\.)/ }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_dependency "compass"
  spec.add_dependency "fontcustom", "~> 1.3.3"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
end
