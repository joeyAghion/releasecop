# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'releasecop/version'

Gem::Specification.new do |spec|
  spec.name          = "releasecop"
  spec.version       = Releasecop::VERSION
  spec.authors       = ["Joey Aghion"]
  spec.email         = ["joey@aghion.com"]
  spec.summary       = %q{Given a list of projects and environments pipelines, report which environments are "behind" and by which commits.}
  spec.homepage      = "https://github.com/joeyAghion/releasecop"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
