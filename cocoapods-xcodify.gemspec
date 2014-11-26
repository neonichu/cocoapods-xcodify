# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods_xcodify/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name          = "cocoapods-xcodify"
  spec.version       = CocoapodsXcodify::VERSION
  spec.authors       = ["Boris Bügling"]
  spec.email         = ["boris@icculus.org"]
  spec.description   = %q{A CocoaPods plugin that allows you to produce a throw-away Xcode project.}
  spec.summary       = %q{This plugin allows you to produce a throw-away Xcode project based on your podspec, so that library consumers can integrate that without using CocoaPods and you don’t have to spend time maintaining a feature you don’t use.}
  spec.homepage      = "https://github.com/EXAMPLE/cocoapods-xcodify"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
