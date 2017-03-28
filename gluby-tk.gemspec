# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gluby-tk/version'

Gem::Specification.new do |spec|
  spec.name          = "gluby-tk"
  spec.version       = GlubyTK::VERSION
  spec.authors       = ["i2097i"]
  spec.email         = ["i2097i@hotmail.com"]
  spec.summary       = "Ruby+GTK+Glade"
  spec.description   = "A tool for creating GTK applications using Ruby and Glade"
  spec.homepage      = "https://github.com/i2097i/gluby-tk"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = ["gluby-tk"]
  spec.require_paths = ["lib"]
  spec.files         = Dir['lib/**/*.rb'] + Dir['templates/**/*']

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency 'gtk3', '~> 3.1.1'
end
