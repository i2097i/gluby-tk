# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rgtk/version'

Gem::Specification.new do |spec|
  spec.name          = "rgtk"
  spec.version       = Rgtk::VERSION
  spec.authors       = ["i2097i"]
  spec.email         = ["i2097i@hotmail.com"]
  spec.summary       = "Ruby+GTK+Glade"
  spec.description   = "A tool for creating GTK applications using Ruby and Glade"
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = ["rgtk"]
  spec.require_paths = ["lib"]
  spec.files         = Dir['lib/**/*.rb'] + Dir['templates/**/*']

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency 'gtk3', '~> 3.1.1'
end
