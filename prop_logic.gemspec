# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prop_logic/version'

Gem::Specification.new do |spec|
  spec.name          = "prop_logic"
  spec.version       = PropLogic::VERSION
  spec.authors       = ["Jkr2255"]
  spec.email         = ["magnesium.oxide.play@gmail.com"]

  spec.summary       = %q{Propositional logic for Ruby}
  spec.description   = %q{Write propositional logic formulae using Ruby DSL.}
  spec.homepage      = "https://github.com/jkr2255/prop_logic"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  
  spec.add_dependency "ref", '~> 2.0'
  spec.required_ruby_version = '>= 2.0.0'


  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", '~> 3.0'
  # spec.add_development_dependency "pry-byebug", '~> 3.3'
end
