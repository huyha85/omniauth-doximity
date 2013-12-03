# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth/doximity/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth-doximity"
  spec.version       = Omniauth::Doximity::VERSION
  spec.authors       = ["HuyHa+QuangLe"]
  spec.email         = ["huy.ha@eastagile.com"]
  spec.description   = %q{Omniauth Strategy for Doximity}
  spec.summary       = %q{Omniauth Strategy for Doximity. Find out Doximity at doximity.com}
  spec.homepage      = "https://github.com/huyha85/omniauth-doximity"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
