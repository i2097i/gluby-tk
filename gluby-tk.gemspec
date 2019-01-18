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
  spec.executables   = ["gluby"]
  spec.require_paths = ["lib"]
  spec.files         = Dir['lib/**/*.rb'] + Dir['templates/**/*']

  spec.add_development_dependency "bundler", "~> 2.0", ">= 2.0.1"
  spec.add_development_dependency "rake", "~> 12.3", ">= 12.3.2"
  spec.add_development_dependency "rspec", "~> 3.8", ">= 3.8.0"
  spec.add_runtime_dependency "gtk3", "~> 3.1", ">= 3.1.1"
  spec.add_runtime_dependency "nokogiri", "~> 1.10", ">= 1.10.1"
  spec.add_runtime_dependency "wannabe_bool", "~> 0.7", ">= 0.7.1"
  spec.add_runtime_dependency "listen", "~> 3.1", ">= 3.1.5"
  spec.add_runtime_dependency "twitter", "~> 6.2", ">= 6.2.0"
end
